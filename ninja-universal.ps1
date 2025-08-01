<#
.SYNOPSIS
    Download and optionally install the latest NinjaOne agent.
.VERSION
    0.1.0
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
    Install the agent after downloading (default: download only).
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
.EXAMPLE
    # Download only
    .\ninja-universal.ps1 -ClientId 'your-id' -ClientSecret 'your-secret'
.
.EXAMPLE
    # Download and install
    .\ninja-universal.ps1 -Install -Region EU -ClientId 'your-id' -ClientSecret 'your-secret'
#>
[CmdletBinding()]
param (
    [switch]$Install,
    [switch]$Gui,
    [switch]$NoGui,
[ValidateSet('US','US2','CA','EU','OC','NA')]
    [string]$Region = 'US',
[string]$InstallerType,
    [string]$ClientId,
    [string]$ClientSecret
)

# Default to install behavior if -Install not specified
if (-not $PSBoundParameters.ContainsKey('Install')) {
    $Install = $true
}

# ── Usage reporting & error tracking ──────────────────────────────────
Trap {
    Write-Host "[ERROR] $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please report this error at https://github.com/baphomet480/ninjaone-universal-installer/issues" -ForegroundColor Yellow
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
function Ensure-Module {
    param([string]$Name)
    if (-not (Get-Module -ListAvailable -Name $Name)) {
        Write-Host "[INFO] Installing module $Name…" -ForegroundColor Cyan
        Install-Module $Name -Force -Scope AllUsers -Repository PSGallery
    }
}

# ── helper: numeric picker (no GUI libs needed) ───────────────────────
function Pick-Item ($Prompt, $Items, $Display = 'name') {
    Write-Host ""
    for ($i = 0; $i -lt $Items.Count; $i++) {
        Write-Host ("{0,3}) {1}" -f $i, $Items[$i].$Display)
    }
    do {
        $sel = Read-Host "$Prompt (0-$($Items.Count-1))"
        if ([string]::IsNullOrWhiteSpace($sel)) {
            throw "No selection provided. Please rerun the script and choose a valid option."
        }
    } until ($sel -as [int] -ge 0 -and $sel -lt $Items.Count)
    return $Items[$sel]
}

$ProgressPreference = 'SilentlyContinue'

# ── elevation when -Install requested ─────────────────────────────────
function Ensure-Admin {
    if ($IsWindows) {
        $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
                   ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if (-not $isAdmin) {
            Write-Host "[INFO] Relaunching elevated…" -ForegroundColor Cyan
            $args = $MyInvocation.UnboundArguments -join ' '
            Start-Process -FilePath (Get-Process -Id $PID).Path -Verb RunAs \
                -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command & `\"$PSCommandPath`\" $args"
            exit
        }
    }
    elseif ($IsLinux -and (whoami) -ne 'root') {
        if (-not (Get-Command sudo -EA SilentlyContinue)) {
            throw "Need sudo for -Install but sudo not found."
        }
    }
}

if ($Install) { Ensure-Admin }

# ── module prep (TLS 1.2 fix for WinPS 5) ─────────────────────────────
if ($PSVersionTable.PSVersion.Major -lt 6) {
    [Net.ServicePointManager]::SecurityProtocol = 3072
}

Ensure-Module PowerShellGet
Ensure-Module NinjaOne
Import-Module  NinjaOne

# ── Credential precedence: CLI > ENV ──────────────────────────────────
$CID = if ($ClientId) { $ClientId } elseif ($Env:NINJA_CLIENT_ID) { $Env:NINJA_CLIENT_ID } else { '' }
$CSC = if ($ClientSecret) { $ClientSecret } elseif ($Env:NINJA_CLIENT_SECRET) { $Env:NINJA_CLIENT_SECRET } else { '' }

if (-not $CID -or -not $CSC) {
    throw "Provide -ClientId / -ClientSecret or set NINJA_CLIENT_ID / NINJA_CLIENT_SECRET."
}

# Allow "NA" (North America) as an alias for the default "US" cloud
$Region = if ($Region.ToUpper() -eq 'NA') { 'US' } else { $Region }

# Connect to NinjaOne API using client credentials (client-only flow)
if (-not (Get-Command Connect-NinjaOne -ErrorAction SilentlyContinue)) {
    throw "Connect-NinjaOne cmdlet not found. Ensure the NinjaOne module is installed."
}
Connect-NinjaOne -ClientId $CID -ClientSecret $CSC -Instance $Region.ToLower() -Scopes management,monitoring -UseClientAuth

# ── choose Org & Location ─────────────────────────────────────────────
$org = Pick-Item "Select organisation" (Get-NinjaOneOrganizations | Sort-Object Name)
$loc = Pick-Item "Select location"     (Get-NinjaOneLocations -organisationId $org.Id | Sort-Object Name)

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

Write-Host "[INFO] Downloading → $Out …" -ForegroundColor Cyan
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
        Write-Host "[WARN] Not running as root; package installation may fail. Consider re-running under sudo." -ForegroundColor Yellow
    }
    if ($IsWindows) {
        Write-Host "[INFO] Installing MSI…" -ForegroundColor Cyan
        $old = Get-WmiObject -Class Win32_Product | Where-Object Name -match 'ninjarmm-agent'
        if ($old) { msiexec /x $old.IdentifyingNumber /qn }
        Start-Process msiexec -Wait -ArgumentList "/i `"$Out`" /qn /norestart"
        Start-Service ninjarmm-agent -EA SilentlyContinue; Start-Service ninjaone-agent -EA SilentlyContinue
    }
    elseif ($IsLinux) {
        if ($InstallerType -eq 'LINUX_DEB') {
            apt remove -y ninjarmm-agent 2>/dev/null
            if ($AddGuiLibs) {
                apt update -y
                apt install -y libgl1 libegl1 libx11-xcb1 libxkbcommon0 libxkbcommon-x11-0
            }
            apt install -y "$Out"
        } else {
            dnf remove -y ninjarmm-agent 2>/dev/null
            if ($AddGuiLibs) {
                dnf install -y mesa-libGL mesa-libEGL libX11 libxkbcommon libxkbcommon-x11
            }
            dnf install -y "$Out"
        }
        systemctl daemon-reload
        foreach ($svc in 'ninjarmm-agent','ninjaone-agent') {
            if (systemctl cat $svc 2>$null) { systemctl enable --now $svc }
        }
    }
    Write-Host "`n[OK] Agent installed and running." -ForegroundColor Green
}

Write-Host "`n[DONE] Latest installer saved at $Out"
