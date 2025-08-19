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

# Prefer local module during refactor; fall back to Global NinjaOne
$localModule = Join-Path $PSScriptRoot 'src/NinjaUniversal/NinjaUniversal.psd1'
if (Test-Path $localModule) { Import-Module $localModule -Force }
Install-RequiredModule PowerShellGet
Install-RequiredModule NinjaOne
Import-Module  NinjaOne

# ── Credential precedence + auth via module ───────────────────────────
$CID = if ($ClientId) { $ClientId } elseif ($Env:NINJA_CLIENT_ID) { $Env:NINJA_CLIENT_ID } else { '' }
$CSC = if ($ClientSecret) { $ClientSecret } elseif ($Env:NINJA_CLIENT_SECRET) { $Env:NINJA_CLIENT_SECRET } else { '' }
Get-NinjaAuth -Region $Region -ClientId $CID -ClientSecret $CSC -NonInteractive:$NonInteractive | Out-Null

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
$lnk = Get-NinjaInstallerLink -Organization $org -Location $loc -InstallerType $InstallerType
$InstallerType = $lnk.Type
$res = Invoke-NinjaInstall -Url $lnk.Url -Type $InstallerType -AddGuiLibs:$AddGuiLibs
$Out = $res.Out

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
    # Module performed install already; nothing else to do here
    Write-Information "`n[OK] Agent installed and running." -InformationAction Continue
}

Write-Information "`n[DONE] Latest installer saved at $Out" -InformationAction Continue
