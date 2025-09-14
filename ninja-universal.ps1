<#
.SYNOPSIS
    Download and optionally install the latest NinjaOne agent.
.VERSION
    0.2.0
.
.DESCRIPTION
    - Authenticates to the NinjaOne Public API v2.
    - Lets you choose Organization → Location interactively.
    - Downloads the freshest agent build for the selected location.
    - Optionally installs the agent (handles elevation, removes older versions).
    - Adds GUI/OpenGL libraries on Linux when needed.
.
.NOTES
    Version: 0.2.0
.PARAMETER Install
    Install the agent after downloading (default: enabled).
.
.PARAMETER Gui
    Force-install GUI libraries on Linux (default: auto-detect).
.
.PARAMETER NoGui
    Force-skip GUI libraries on Linux (default: auto-detect).
.
.PARAMETER Region
    Tenant region. Valid values: US (default), US2, CA, EU, OC.
.
.PARAMETER InstallerType
    Installer type (optional). Valid values: WINDOWS_MSI, LINUX_DEB, LINUX_RPM, MAC_PKG. Auto-chosen if omitted.
.
.PARAMETER ClientId
    NinjaOne API client Id (overrides NINJA_CLIENT_ID env var).
.
.PARAMETER ClientSecret
    NinjaOne API client secret (overrides NINJA_CLIENT_SECRET env var).
.
.PARAMETER Organization
    Organization Id or Name (skips interactive pick when provided).
.
.PARAMETER Location
    Location Id or Name (skips interactive pick when provided).
.
.PARAMETER NonInteractive
    Fail if interaction is required (do not prompt). Useful for CI.
.
.EXAMPLE
    # Download only
    .\ninja-universal.ps1 -ClientId 'your-id' -ClientSecret 'your-secret'
.
.EXAMPLE
    # Download and install
    .\ninja-universal.ps1 -Install -Region EU -ClientId 'your-id' -ClientSecret 'your-secret'
#
.EXAMPLE
    # Fully non-interactive
    .\ninja-universal.ps1 -Organization "Acme Co" -Location "HQ" -NonInteractive
#>
[CmdletBinding()]
param (
    [switch]$Install,
    [switch]$Gui,
    [switch]$NoGui,
    [ValidateSet('US','US2','CA','EU','OC','NA')]
    [string]$Region = 'US',
    [ValidateSet('WINDOWS_MSI','LINUX_DEB','LINUX_RPM','MAC_PKG')]
    [string]$InstallerType,
    [string]$ClientId,
    [string]$ClientSecret,
    [string]$RefreshToken,
    [switch]$UseDeviceCode,
    [switch]$UseWebAuth,
    [string]$Organization,
    [string]$Location,
    [switch]$NonInteractive
)

# Default to install behavior if -Install not specified
if (-not $PSBoundParameters.ContainsKey('Install')) {
    $Install = $true
}

# ── Usage reporting & error tracking ──────────────────────────────────
Trap {
    Write-Error "[ERROR] $($_.Exception.Message)"
    Write-Information "Please report this error at https://github.com/baphomet480/ninjaone-universal-installer/issues" -InformationAction Continue
    Exit 1
}


# --- Compatibility shim for Windows PowerShell 5.1 ----------------------------
# Automatic boolean variables like $IsWindows / $IsLinux were introduced in
# PowerShell 6+.  They are therefore missing when this script is executed under
# legacy Windows PowerShell 5.x.  A handful of runtime checks below rely on
# these variables, so we create reasonable fall-backs when they are absent.

if (-not (Get-Variable -Name IsWindows -Scope Script -ErrorAction SilentlyContinue)) {
    # pre-PowerShell 6 implies Windows only
    $Script:IsWindows = $true
}
if (-not (Get-Variable -Name IsLinux -Scope Script -ErrorAction SilentlyContinue)) {
    $Script:IsLinux   = $false
}
if (-not (Get-Variable -Name IsMacOS -Scope Script -ErrorAction SilentlyContinue)) {
    $Script:IsMacOS   = $false
}

# ── helper: ensure PSGallery module ────────────────────────────────────
function Install-RequiredModule {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Name)
    if (-not (Get-Module -ListAvailable -Name $Name)) {
        Write-Information "[INFO] Installing module $Name…" -InformationAction Continue
        Install-Module $Name -Force -Scope CurrentUser -Repository PSGallery
    }
}
# Back-compat alias for any external callers
Set-Alias -Name Ensure-Module -Value Install-RequiredModule -Scope Script

# ── helper: numeric picker (no GUI libs needed) ───────────────────────
function Select-FromList {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Prompt,
        [Parameter(Mandatory)][array]$Items,
        [string]$Display = 'name'
    )
    Write-Information "" -InformationAction Continue
    for ($i = 0; $i -lt $Items.Count; $i++) {
        Write-Information ("{0,3}) {1}" -f $i, $Items[$i].$Display) -InformationAction Continue
    }
    do {
        $sel = Read-Host "$Prompt (0-$($Items.Count-1))" -ErrorAction SilentlyContinue
        if ([string]::IsNullOrWhiteSpace($sel)) {
            Write-Information "[INPUT] Enter selection:" -InformationAction Continue
            $sel = [Console]::In.ReadLine()
        }
        if ([string]::IsNullOrWhiteSpace($sel)) {
            throw "No selection provided. Please rerun the script and choose a valid option."
        }
    } until ($sel -as [int] -ge 0 -and $sel -lt $Items.Count)
    return $Items[$sel]
}
# Back-compat alias
Set-Alias -Name Pick-Item -Value Select-FromList -Scope Script

$ProgressPreference = 'SilentlyContinue'

# ── elevation when -Install requested ─────────────────────────────────
function Start-AdminElevation {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param()
    if ($IsWindows) {
        $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
                   ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if (-not $isAdmin) {
            if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Relaunch elevated')) {
                Write-Information "[INFO] Relaunching elevated…" -InformationAction Continue
                $relaunchArgs = $MyInvocation.UnboundArguments -join ' '
                Start-Process -FilePath (Get-Process -Id $PID).Path -Verb RunAs \
                    -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command & `\"$PSCommandPath`\" $relaunchArgs"
                exit
            }
        }
    }
    elseif ($IsLinux -and (whoami) -ne 'root') {
        if (-not (Get-Command sudo -EA SilentlyContinue)) {
            throw "Need sudo for -Install but sudo not found."
        }
    }
}

if ($Install) { Start-AdminElevation }

# ── module prep (TLS 1.2 fix for WinPS 5) ─────────────────────────────
if ($PSVersionTable.PSVersion.Major -lt 6) {
    [Net.ServicePointManager]::SecurityProtocol = 3072
}

# Prefer local module during refactor; fall back to Global NinjaOne
$localModule = Join-Path $PSScriptRoot 'src/NinjaUniversal/NinjaUniversal.psd1'
if (Test-Path $localModule) { Import-Module $localModule -Force }
Install-RequiredModule PowerShellGet
Install-RequiredModule NinjaOne
Import-Module  NinjaOne

# Embed minimal helper shims when the local module isn't present
if (-not (Get-Command Get-NinjaAuth -ErrorAction SilentlyContinue)) {
    function Select-NinjaItem {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)][string]$Prompt,
            [Parameter(Mandatory)][array]$Items,
            [string]$Display = 'name'
        )
        for ($i=0; $i -lt $Items.Count; $i++) {
            Write-Information ("{0,3}) {1}" -f $i, $Items[$i].$Display) -InformationAction Continue
        }
        do { $sel = Read-Host "$Prompt (0-$($Items.Count-1))" -ErrorAction SilentlyContinue } until ($sel -as [int] -ge 0 -and $sel -lt $Items.Count)
        return $Items[$sel]
    }

    function Get-NinjaAuth {
        [CmdletBinding()]
        [OutputType([hashtable])]
        param(
            [ValidateSet('US','US2','CA','EU','OC','NA')]
            [string]$Region = 'US',
            [string]$ClientId,
            [string]$ClientSecret,
            [string]$RefreshToken,
            [switch]$NonInteractive,
            [switch]$UseDeviceCode,
            [switch]$UseWebAuth
        )
        $Region = if ($Region.ToUpper() -eq 'NA') { 'US' } else { $Region }
        if (-not (Get-Command Connect-NinjaOne -ErrorAction SilentlyContinue)) {
            throw "Connect-NinjaOne cmdlet not found. Ensure the NinjaOne module is installed."
        }
        if ($RefreshToken) {
            $splat = @{ Instance = $Region.ToLower(); UseTokenAuth = $true; RefreshToken = $RefreshToken }
            if ($ClientId)    { $splat.ClientId    = $ClientId }
            if ($ClientSecret){ $splat.ClientSecret= $ClientSecret }
            Connect-NinjaOne @splat | Out-Null
            return @{ Mode='Token'; Region=$Region }
        }
        if ($ClientId -and $ClientSecret) {
            Connect-NinjaOne -ClientId $ClientId -ClientSecret $ClientSecret -Instance $Region.ToLower() -Scopes management,monitoring -UseClientAuth | Out-Null
            return @{ Mode='Client'; Region=$Region }
        }
        if ($NonInteractive) { throw "Missing credentials in non-interactive mode." }

        $uiAvailable = $false
        try {
            if ($IsLinux) { $uiAvailable = [bool]($Env:DISPLAY -or $Env:WAYLAND_DISPLAY) }
            elseif ($IsWindows -or $IsMacOS) { $uiAvailable = [Environment]::UserInteractive }
        } catch { $uiAvailable = $false }

        # Explicit device-code request
        if ($UseDeviceCode) {
            $cmd = Get-Command Connect-NinjaOne
            $paramName = @('UseDeviceCode','UseDeviceAuth','DeviceCode') | Where-Object { $cmd.Parameters.ContainsKey($_) } | Select-Object -First 1
            if ($paramName) {
                Write-Information "[INFO] Starting device code authentication…" -InformationAction Continue
                $splat = @{ Instance = $Region.ToLower(); Scopes = 'management,monitoring' }
                $splat[$paramName] = $true
                Connect-NinjaOne @splat | Out-Null
                return @{ Mode='DeviceCode'; Region=$Region }
            }
            throw "Device code auth not supported by current NinjaOne module. Use -UseWebAuth (with a browser) or -ClientId/-ClientSecret."
        }

        # Explicit web auth request
        if ($UseWebAuth) {
            if (-not $uiAvailable) { throw "Web authentication requires a local browser/UI; use -ClientId/-ClientSecret instead." }
            Write-Information "[INFO] Launching interactive NinjaOne login…" -InformationAction Continue
            Connect-NinjaOne -Instance $Region.ToLower() -Scopes management,monitoring -UseWebAuth | Out-Null
            return @{ Mode='Interactive'; Region=$Region }
        }

        # Auto: prefer web auth if UI available; otherwise require client credentials
        if ($uiAvailable) {
            Write-Information "[INFO] Launching interactive NinjaOne login…" -InformationAction Continue
            Connect-NinjaOne -Instance $Region.ToLower() -Scopes management,monitoring -UseWebAuth | Out-Null
            return @{ Mode='Interactive'; Region=$Region }
        }

        throw "No browser UI available and device code not requested/supported. Provide -ClientId/-ClientSecret or run with -UseWebAuth on a machine with a browser."
    }

    function Select-NinjaOrganization {
        [CmdletBinding()]
        param([string]$Organization,[switch]$NonInteractive)
        $orgs = Get-NinjaOneOrganizations | Sort-Object Name
        if ($Organization) {
            $match = $orgs | Where-Object { $_.Id -eq $Organization -or $_.Name -eq $Organization }
            if (-not $match) { $match = $orgs | Where-Object { $_.Name -like "*$Organization*" } }
            if (-not $match) { throw "Organization '$Organization' not found." }
            if ($match.Count -gt 1 -and $NonInteractive) { throw "Multiple organizations matched '$Organization'." }
            if ($match.Count -gt 1) { return Select-NinjaItem -Prompt 'Select organisation' -Items $match }
            return $match[0]
        }
        if ($orgs.Count -eq 1) { return $orgs[0] }
        if ($NonInteractive) { throw "Multiple organizations found; provide -Organization." }
        return Select-NinjaItem -Prompt 'Select organisation' -Items $orgs
    }

    function Select-NinjaLocation {
        [CmdletBinding()]
        param([Parameter(Mandatory)][object]$Organization,[string]$Location,[switch]$NonInteractive)
        $locs = Get-NinjaOneLocations -organisationId $Organization.Id | Sort-Object Name
        if ($Location) {
            $match = $locs | Where-Object { $_.Id -eq $Location -or $_.Name -eq $Location }
            if (-not $match) { $match = $locs | Where-Object { $_.Name -like "*$Location*" } }
            if (-not $match) { throw "Location '$Location' not found in '$($Organization.Name)'." }
            if ($match.Count -gt 1 -and $NonInteractive) { throw "Multiple locations matched '$Location'." }
            if ($match.Count -gt 1) { return Select-NinjaItem -Prompt 'Select location' -Items $match }
            return $match[0]
        }
        if ($locs.Count -eq 1) { return $locs[0] }
        if ($NonInteractive) { throw "Multiple locations found; provide -Location." }
        return Select-NinjaItem -Prompt 'Select location' -Items $locs
    }

    function Get-NinjaInstallerLink {
        [CmdletBinding()]
        param([Parameter(Mandatory)][object]$Organization,[Parameter(Mandatory)][object]$Location,[ValidateSet('WINDOWS_MSI','LINUX_DEB','LINUX_RPM','MAC_PKG')][string]$InstallerType)
        if (-not $InstallerType) {
            if     ($IsWindows) { $InstallerType = 'WINDOWS_MSI' }
            elseif ($IsLinux)   { $InstallerType = (Get-Command apt -EA 0) ? 'LINUX_DEB' : 'LINUX_RPM' }
            else                { $InstallerType = 'MAC_PKG' }
        }
        $link = Get-NinjaOneInstaller -organisationId $Organization.id -locationId $Location.id -installerType $InstallerType
        return [pscustomobject]@{ Type=$InstallerType; Url=$link.url }
    }

    function Remove-NinjaAgent {
        [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
        param()
        if ($IsWindows) {
            $paths = @('HKLM:\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\*','HKLM:\\Software\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\*')
            $entries = Get-ItemProperty -Path $paths -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -and ($_.DisplayName -match 'ninja.*agent') }
            foreach ($e in $entries) {
                try {
                    $guid = $null
                    if ($e.PSChildName -match '^\{[0-9A-Fa-f-]+\}$') { $guid = $e.PSChildName }
                    elseif ($e.UninstallString -and ($e.UninstallString -match '\\{[0-9A-Fa-f-]+\\}')) { $guid = $Matches[0] }
                    if ($guid) { if ($PSCmdlet.ShouldProcess("$($e.DisplayName) $guid", 'Uninstall')) { Start-Process msiexec.exe -ArgumentList "/x $guid /qn /norestart" -Wait } }
                } catch { Write-Verbose "Uninstall probe failed: $($_.Exception.Message)" }
            }
            return
        }
        if ($IsLinux) {
            if (Get-Command apt-get -EA 0) {
                & systemctl stop ninjarmm-agent 2>$null; & systemctl stop ninjaone-agent 2>$null
                & apt-get remove -y 'ninja*-agent*' 'ninjaone-agent*' 'ninjarmm-agent*' 2>$null
                & dpkg --purge ninjaone-agent* 2>$null
            } else {
                & systemctl stop ninjarmm-agent 2>$null; & systemctl stop ninjaone-agent 2>$null
                $rpmPkgs = (& rpm -qa 2>$null | Where-Object { $_ -match 'ninja.*agent' })
                if ($rpmPkgs) { dnf remove -y $rpmPkgs }
            }
        }
    }

    function Invoke-NinjaInstall {
        [CmdletBinding()]
        [OutputType([hashtable])]
        param([Parameter(Mandatory)][string]$Url,[Parameter(Mandatory)][string]$Type,[switch]$AddGuiLibs)
        $ext = ($Type -split '_')[-1].ToLower()
        $out = Join-Path ([IO.Path]::GetTempPath()) "ninja.$ext"
        Invoke-WebRequest $Url -UseBasicParsing -Headers @{ 'User-Agent'='Mozilla/5.0' } -OutFile $out
        if ($IsWindows) {
            foreach ($svc in 'ninjarmm-agent','ninjaone-agent') { try { Stop-Service $svc -Force -EA SilentlyContinue } catch { Write-Verbose "Stop $svc failed: $($_.Exception.Message)" } }
            Remove-NinjaAgent -Confirm:$false
            Start-Process msiexec -Wait -ArgumentList "/i `"$out`" /qn /norestart"
            Start-Service ninjarmm-agent -EA SilentlyContinue; Start-Service ninjaone-agent -EA SilentlyContinue
        } elseif ($IsLinux) {
            foreach ($svc in 'ninjarmm-agent','ninjaone-agent') { try { & systemctl stop $svc 2>$null } catch { Write-Verbose "stop $svc failed: $($_.Exception.Message)" } }
            if ($Type -eq 'LINUX_DEB') {
                if ($AddGuiLibs) { apt-get update -y || $true; apt-get install -y libgl1 libegl1 libx11-xcb1 libxkbcommon0 libxkbcommon-x11-0 }
                apt-get install -y "$out"
            } else {
                if ($AddGuiLibs) { dnf install -y mesa-libGL mesa-libEGL libX11 libxkbcommon libxkbcommon-x11 }
                dnf install -y "$out"
            }
            systemctl daemon-reload
            foreach ($svc in 'ninjarmm-agent','ninjaone-agent') { $null = & systemctl cat $svc 2>$null; if ($LASTEXITCODE -eq 0) { & systemctl enable --now $svc } }
        }
        return @{ Out = $out }
    }
}

# ── Credential precedence + auth via module ───────────────────────────
$CID = if ($ClientId) { $ClientId } elseif ($Env:NINJA_CLIENT_ID) { $Env:NINJA_CLIENT_ID } else { '' }
$CSC = if ($ClientSecret) { $ClientSecret } elseif ($Env:NINJA_CLIENT_SECRET) { $Env:NINJA_CLIENT_SECRET } else { '' }
$RTK = if ($RefreshToken) { $RefreshToken } elseif ($Env:NINJA_REFRESH_TOKEN) { $Env:NINJA_REFRESH_TOKEN } else { '' }
Get-NinjaAuth -Region $Region -ClientId $CID -ClientSecret $CSC -RefreshToken $RTK -NonInteractive:$NonInteractive -UseDeviceCode:$UseDeviceCode -UseWebAuth:$UseWebAuth | Out-Null

# ── choose Org & Location via module ──────────────────────────────────
$org = Select-NinjaOrganization -Organization $Organization -NonInteractive:$NonInteractive
$loc = Select-NinjaLocation -Organization $org -Location $Location -NonInteractive:$NonInteractive

# ── pick auto installer type if omitted ───────────────────────────────
if (-not $InstallerType) {
if     ($IsWindows) {
    $InstallerType = 'WINDOWS_MSI'
}
elseif ($IsLinux) {
    if (Get-Command apt -ErrorAction SilentlyContinue) {
        $InstallerType = 'LINUX_DEB'
    }
    else {
        $InstallerType = 'LINUX_RPM'
    }
}
else {
    $InstallerType = 'MAC_PKG'
}
}

# ── Generate installer URL & download/install via module ──────────────

# ── Decide if GUI libs needed on Linux─────────────────────────────────
function Test-GuiPresent {
    $Env:DISPLAY -or $Env:WAYLAND_DISPLAY -or (Get-Command Xorg,Xwayland -EA 0)
}
if ($Gui -and $NoGui) { throw "Cannot use both -Gui and -NoGui." }
$AddGuiLibs = $false
if ($IsLinux) {
    if ($Gui)       { $AddGuiLibs = $true }
    elseif ($NoGui) { $AddGuiLibs = $false }
    else            { $AddGuiLibs = [bool](Test-GuiPresent) }
}

# ── Generate installer URL & download/install via module ──────────────
$lnk = Get-NinjaInstallerLink -Organization $org -Location $loc -InstallerType $InstallerType
$InstallerType = $lnk.Type
$res = Invoke-NinjaInstall -Url $lnk.Url -Type $InstallerType -AddGuiLibs:$AddGuiLibs
$Out = $res.Out

# ── Install path (if -Install) ────────────────────────────────────────
if ($Install) {
    # Warn if not running as root on Linux; package commands may require sudo
    if ($IsLinux -and ((whoami) -ne 'root')) {
        Write-Warning "Not running as root; package installation may fail. Consider re-running under sudo."
    }
    # Module performed install already; nothing else to do here
    Write-Information "`n[OK] Agent installed and running." -InformationAction Continue
}

Write-Information "`n[DONE] Latest installer saved at $Out" -InformationAction Continue
