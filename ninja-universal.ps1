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
    Version: 0.1.0
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
        Install-Module $Name -Force -Scope AllUsers -Repository PSGallery
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

Install-RequiredModule PowerShellGet
Install-RequiredModule NinjaOne
Import-Module  NinjaOne

# ── Credential precedence: CLI > ENV; fallback to interactive web auth ─
$CID = if ($ClientId) { $ClientId } elseif ($Env:NINJA_CLIENT_ID) { $Env:NINJA_CLIENT_ID } else { '' }
$CSC = if ($ClientSecret) { $ClientSecret } elseif ($Env:NINJA_CLIENT_SECRET) { $Env:NINJA_CLIENT_SECRET } else { '' }

# Allow "NA" (North America) as an alias for the default "US" cloud
$Region = if ($Region.ToUpper() -eq 'NA') { 'US' } else { $Region }

# Connect to NinjaOne API (prefer client creds; else interactive when allowed)
if (-not (Get-Command Connect-NinjaOne -ErrorAction SilentlyContinue)) {
    throw "Connect-NinjaOne cmdlet not found. Ensure the NinjaOne module is installed."
}
if ($CID -and $CSC) {
    Connect-NinjaOne -ClientId $CID -ClientSecret $CSC -Instance $Region.ToLower() -Scopes management,monitoring -UseClientAuth
}
else {
    if ($NonInteractive) {
        throw "Missing credentials. Provide -ClientId/-ClientSecret or set NINJA_CLIENT_ID/NINJA_CLIENT_SECRET."
    }
    Write-Information "[INFO] No client credentials found. Launching interactive login…" -InformationAction Continue
    try {
        Connect-NinjaOne -Instance $Region.ToLower() -Scopes management,monitoring -UseWebAuth
    } catch {
        throw "Interactive login failed or not supported. Provide -ClientId/-ClientSecret or set NINJA_CLIENT_ID/NINJA_CLIENT_SECRET. Error: $($_.Exception.Message)"
    }
}

# ── choose Org & Location ─────────────────────────────────────────────
function Resolve-ByNameOrId {
    param(
        [Parameter(Mandatory)][array]$Items,
        [Parameter(Mandatory)][string]$Value
    )
    $match = $Items | Where-Object { $_.Id -eq $Value -or $_.id -eq $Value -or $_.Name -eq $Value -or $_.name -eq $Value }
    if (-not $match) {
        $match = $Items | Where-Object { $_.Name -like "*$Value*" -or $_.name -like "*$Value*" }
    }
    return $match
}

$orgs = Get-NinjaOneOrganizations | Sort-Object Name
if ($Organization) {
    $candidates = Resolve-ByNameOrId -Items $orgs -Value $Organization
    if (-not $candidates) { throw "Organization '$Organization' not found." }
    if ($candidates.Count -gt 1) {
        if ($NonInteractive) { throw "Multiple organizations matched '$Organization'. Be more specific." }
        $org = Select-FromList -Prompt "Select organisation" -Items $candidates
    } else { $org = $candidates[0] }
} elseif ($orgs.Count -eq 1) {
    $org = $orgs[0]
} else {
    if ($NonInteractive) { throw "Multiple organizations found. Provide -Organization to avoid prompts." }
    $org = Select-FromList -Prompt "Select organisation" -Items $orgs
}

$locs = Get-NinjaOneLocations -organisationId $org.Id | Sort-Object Name
if ($Location) {
    $lc = Resolve-ByNameOrId -Items $locs -Value $Location
    if (-not $lc) { throw "Location '$Location' not found in '$($org.Name)'." }
    if ($lc.Count -gt 1) {
        if ($NonInteractive) { throw "Multiple locations matched '$Location'. Be more specific." }
        $loc = Select-FromList -Prompt "Select location" -Items $lc
    } else { $loc = $lc[0] }
} elseif ($locs.Count -eq 1) {
    $loc = $locs[0]
} else {
    if ($NonInteractive) { throw "Multiple locations found. Provide -Location to avoid prompts." }
    $loc = Select-FromList -Prompt "Select location" -Items $locs
}

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

# ── Generate installer URL & download ─────────────────────────────────
$link = Get-NinjaOneInstaller -organisationId $org.id -locationId $loc.id -installerType $InstallerType
$ext  = ($InstallerType -split '_')[-1].ToLower()
$Out  = Join-Path ([IO.Path]::GetTempPath()) "ninja.$ext"

Write-Information "[INFO] Downloading → $Out …" -InformationAction Continue
Invoke-WebRequest $link.url -UseBasicParsing -Headers @{ 'User-Agent' = 'Mozilla/5.0' } -OutFile $Out

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

# ── Install path (if -Install) ────────────────────────────────────────
if ($Install) {
    # Warn if not running as root on Linux; package commands may require sudo
    if ($IsLinux -and ((whoami) -ne 'root')) {
        Write-Warning "Not running as root; package installation may fail. Consider re-running under sudo."
    }
    if ($IsWindows) {
        Write-Information "[INFO] Installing MSI…" -InformationAction Continue

        function Remove-WindowsNinjaAgent {
            [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
            param()
            # Prefer registry-based uninstall over Win32_Product to avoid MSI self-repair
            $paths = @(
                'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
            )
            $entries = Get-ItemProperty -Path $paths -ErrorAction SilentlyContinue | Where-Object {
                $_.DisplayName -and ($_.DisplayName -match 'ninja.*agent')
            }
            foreach ($e in $entries) {
                try {
                    $guid = $null
                    if ($e.PSChildName -match '^\{[0-9A-Fa-f-]+\}$') { $guid = $e.PSChildName }
                    elseif ($e.UninstallString -and ($e.UninstallString -match '\{[0-9A-Fa-f-]+\}')) { $guid = $Matches[0] }

                    if ($guid) {
                        if ($PSCmdlet.ShouldProcess("$($e.DisplayName) $guid", 'Uninstall')) {
                            Write-Information "[INFO] Uninstalling MSI $($e.DisplayName) $guid" -InformationAction Continue
                            Start-Process msiexec.exe -ArgumentList "/x $guid /qn /norestart" -Wait
                        }
                    }
                    elseif ($e.UninstallString) {
                        # Fallback: invoke vendor uninstall string silently when possible
                        $cmd = $e.UninstallString
                        # Replace /I with /X when present
                        $cmd = $cmd -replace '/I','/X'
                        if ($cmd -notmatch '/qn') { $cmd += ' /qn /norestart' }
                        Write-Verbose "Invoking uninstall string: $cmd"
                        $exePath, $exeArgs = $null, $null
                        if ($cmd -match '^("?[^"]+"?)\s*(.*)$') { $exePath = $Matches[1]; $exeArgs = $Matches[2] }
                        if ($exePath -and $PSCmdlet.ShouldProcess($exePath, 'Uninstall via vendor string')) { Start-Process $exePath -ArgumentList $exeArgs -Wait }
                    }
                } catch { Write-Verbose "Uninstall entry failed: $($_.Exception.Message)" }
            }
        }

        # Stop services first, then remove, then install
        foreach ($svc in 'ninjarmm-agent','ninjaone-agent') {
            try { Stop-Service $svc -Force -ErrorAction SilentlyContinue } catch { Write-Verbose "Stop $($svc): $($_.Exception.Message)" }
        }
        Remove-WindowsNinjaAgent

        # Install this MSI
        Start-Process msiexec -Wait -ArgumentList "/i `"$Out`" /qn /norestart"
        # Start the agent services if present
        Start-Service ninjarmm-agent -ErrorAction SilentlyContinue
        Start-Service ninjaone-agent -ErrorAction SilentlyContinue
    }
    elseif ($IsLinux) {
        if ($InstallerType -eq 'LINUX_DEB') {
            foreach ($svc in 'ninjarmm-agent','ninjaone-agent') {
                try { & systemctl stop $svc 2>$null } catch { Write-Verbose "stop $($svc): $($_.Exception.Message)" }
            }
            try {
                # Remove any existing packages matching ninja*agent*
                & apt-get remove -y 'ninja*-agent*' 'ninjaone-agent*' 'ninjarmm-agent*' 2>$null
                & dpkg --purge ninjaone-agent* 2>$null
            } catch { Write-Verbose "apt/dpkg removal skipped: $($_.Exception.Message)" }
            if ($AddGuiLibs) {
                apt-get update -y || $true
                apt-get install -y libgl1 libegl1 libx11-xcb1 libxkbcommon0 libxkbcommon-x11-0
            }
            apt-get install -y "$Out"
        } else {
            foreach ($svc in 'ninjarmm-agent','ninjaone-agent') {
                try { & systemctl stop $svc 2>$null } catch { Write-Verbose "stop $($svc): $($_.Exception.Message)" }
            }
            try {
                $rpmPkgs = (& rpm -qa 2>$null | Where-Object { $_ -match 'ninja.*agent' })
                if ($rpmPkgs) { dnf remove -y $rpmPkgs }
            } catch { Write-Verbose "dnf removal skipped: $($_.Exception.Message)" }
            if ($AddGuiLibs) {
                dnf install -y mesa-libGL mesa-libEGL libX11 libxkbcommon libxkbcommon-x11
            }
            dnf install -y "$Out"
        }
        systemctl daemon-reload
        foreach ($svc in 'ninjarmm-agent','ninjaone-agent') {
            $null = & systemctl cat $svc 2>$null
            if ($LASTEXITCODE -eq 0) { & systemctl enable --now $svc }
        }
    }
    Write-Information "`n[OK] Agent installed and running." -InformationAction Continue
}

Write-Information "`n[DONE] Latest installer saved at $Out" -InformationAction Continue
