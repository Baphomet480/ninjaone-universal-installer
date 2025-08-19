Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Install-RequiredModule {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Name)
    if (-not (Get-Module -ListAvailable -Name $Name)) {
        Write-Information "[INFO] Installing module $Name…" -InformationAction Continue
        Install-Module $Name -Force -Scope AllUsers -Repository PSGallery
    }
}

function Start-Elevation {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param()
    if ($IsWindows) {
        $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
                   ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if (-not $isAdmin) {
            if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, 'Relaunch elevated')) {
                $relaunchArgs = $MyInvocation.UnboundArguments -join ' '
                Start-Process -FilePath (Get-Process -Id $PID).Path -Verb RunAs \
                    -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command & `\"$PSCommandPath`\" $relaunchArgs"
                exit
            }
        }
    }
}

function Get-NinjaAuth {
    [CmdletBinding()]
    param(
        [ValidateSet('US','US2','CA','EU','OC','NA')]
        [string]$Region = 'US',
        [string]$ClientId,
        [string]$ClientSecret,
        [switch]$NonInteractive
    )
    $Region = if ($Region.ToUpper() -eq 'NA') { 'US' } else { $Region }
    if (-not (Get-Command Connect-NinjaOne -ErrorAction SilentlyContinue)) {
        throw "Connect-NinjaOne cmdlet not found. Ensure the NinjaOne module is installed."
    }
    if ($ClientId -and $ClientSecret) {
        Connect-NinjaOne -ClientId $ClientId -ClientSecret $ClientSecret -Instance $Region.ToLower() -Scopes management,monitoring -UseClientAuth | Out-Null
        return @{ Mode='Client'; Region=$Region }
    }
    if ($NonInteractive) { throw "Missing credentials in non-interactive mode." }
    Write-Information "[INFO] Launching interactive NinjaOne login…" -InformationAction Continue
    Connect-NinjaOne -Instance $Region.ToLower() -Scopes management,monitoring -UseWebAuth | Out-Null
    return @{ Mode='Interactive'; Region=$Region }
}

function Select-NinjaOrganization {
    [CmdletBinding()]
    param(
        [string]$Organization,
        [switch]$NonInteractive
    )
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
    param(
        [Parameter(Mandatory)][object]$Organization,
        [string]$Location,
        [switch]$NonInteractive
    )
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
    do {
        $sel = Read-Host "$Prompt (0-$($Items.Count-1))" -ErrorAction SilentlyContinue
    } until ($sel -as [int] -ge 0 -and $sel -lt $Items.Count)
    return $Items[$sel]
}

function Get-NinjaInstallerLink {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object]$Organization,
        [Parameter(Mandatory)][object]$Location,
        [ValidateSet('WINDOWS_MSI','LINUX_DEB','LINUX_RPM','MAC_PKG')]
        [string]$InstallerType
    )
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
        $paths = @('HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                   'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*')
        $entries = Get-ItemProperty -Path $paths -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -and ($_.DisplayName -match 'ninja.*agent') }
        foreach ($e in $entries) {
            try {
                $guid = $null
                if ($e.PSChildName -match '^\{[0-9A-Fa-f-]+\}$') { $guid = $e.PSChildName }
                elseif ($e.UninstallString -and ($e.UninstallString -match '\{[0-9A-Fa-f-]+\}')) { $guid = $Matches[0] }
                if ($guid) {
                    if ($PSCmdlet.ShouldProcess("$($e.DisplayName) $guid", 'Uninstall')) {
                        Start-Process msiexec.exe -ArgumentList "/x $guid /qn /norestart" -Wait
                    }
                }
            } catch {}
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
    param(
        [Parameter(Mandatory)][string]$Url,
        [Parameter(Mandatory)][string]$Type,
        [switch]$AddGuiLibs
    )
    $ext = ($Type -split '_')[-1].ToLower()
    $out = Join-Path ([IO.Path]::GetTempPath()) "ninja.$ext"
    Invoke-WebRequest $Url -UseBasicParsing -Headers @{ 'User-Agent'='Mozilla/5.0' } -OutFile $out
    if ($IsWindows) {
        foreach ($svc in 'ninjarmm-agent','ninjaone-agent') { try { Stop-Service $svc -Force -EA SilentlyContinue } catch {} }
        Remove-NinjaAgent -Confirm:$false
        Start-Process msiexec -Wait -ArgumentList "/i `"$out`" /qn /norestart"
        Start-Service ninjarmm-agent -EA SilentlyContinue; Start-Service ninjaone-agent -EA SilentlyContinue
    } elseif ($IsLinux) {
        if ($Type -eq 'LINUX_DEB') {
            foreach ($svc in 'ninjarmm-agent','ninjaone-agent') { try { & systemctl stop $svc 2>$null } catch {} }
            if ($AddGuiLibs) { apt-get update -y || $true; apt-get install -y libgl1 libegl1 libx11-xcb1 libxkbcommon0 libxkbcommon-x11-0 }
            apt-get install -y "$out"
        } else {
            foreach ($svc in 'ninjarmm-agent','ninjaone-agent') { try { & systemctl stop $svc 2>$null } catch {} }
            if ($AddGuiLibs) { dnf install -y mesa-libGL mesa-libEGL libX11 libxkbcommon libxkbcommon-x1 }
            dnf install -y "$out"
        }
        systemctl daemon-reload
        foreach ($svc in 'ninjarmm-agent','ninjaone-agent') { $null = & systemctl cat $svc 2>$null; if ($LASTEXITCODE -eq 0) { & systemctl enable --now $svc } }
    }
    return @{ Out=$out; Type=$Type }
}

Export-ModuleMember -Function *

