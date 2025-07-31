# NinjaOne Universal Installer

A single self-contained PowerShell script that:

* Authenticates to the NinjaOne Public API v2  
* Lets you choose Organisation → Location interactively  
* Downloads the freshest agent build for that location  
* Optionally installs the agent (handles elevation, removes older versions)  
* Adds GUI / OpenGL libraries on Linux workstations only when needed  

Runs unmodified on **Windows PowerShell 5.x** *and* **PowerShell 7+** on Ubuntu 22/24, Rocky Linux 9, or any other distro with `pwsh`.

---

## Quick usage

```powershell
# Download + install headless
pwsh -NoProfile -Command "
  iwr https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/ninja-universal.ps1 | iex;
  ninja-universal.ps1 -Install -ClientId '<client-id>' -ClientSecret '<secret>'"

## Requirements

- PowerShell 5.x on Windows or PowerShell 7+ (`pwsh`) on supported Linux distributions.
- Internet access to the NinjaOne API and OS package repositories.

## Obtaining API credentials

To use this script, you must supply a NinjaOne API Client Id and Client Secret.

1. Log in to the NinjaOne administrator portal.
2. Navigate to **Settings** → **API** → **API Clients**.
3. Click **Add Client**, provide a name, and save.
4. Copy the **Client Id** and **Client Secret** values.
5. (Optional) You can also set environment variables:

   ```powershell
   $Env:NINJA_CLIENT_ID     = 'your-client-id'
   $Env:NINJA_CLIENT_SECRET = 'your-client-secret'
   ```

## Detailed Usage

### Download only (interactive)
```powershell
.\ninja-universal.ps1 -ClientId 'YOUR_ID' -ClientSecret 'YOUR_SECRET'
```

## Installing PowerShell on Linux

You can install PowerShell on popular Linux distributions using our helper script:

```bash
curl -sSL https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/install-pwsh.sh | sudo bash
```

### Download and install automatically
```powershell
.\ninja-universal.ps1 -Install -Region EU -ClientId 'YOUR_ID' -ClientSecret 'YOUR_SECRET'
```

### Running on Windows PowerShell 5.x

To always fetch the latest script (avoiding cached or stale copies) and run on PowerShell 5.x:
```powershell
# Cleanup any old script
Remove-Item ninja-universal.ps1 -ErrorAction SilentlyContinue

# Download the fresh script (basic parsing for PS5)
iwr https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/ninja-universal.ps1 `
    -UseBasicParsing -OutFile ninja-universal.ps1

# Run the installer with your API credentials
.\
ninja-universal.ps1 -ClientId 'YOUR_ID' -ClientSecret 'YOUR_SECRET' -Install
```

#### Cache‑busting (if behind a proxy/CDN)

If you encounter caching issues, you can force a fresh download in two ways:

1. **Timestamp query**
```powershell
$ts = Get-Date -UFormat %s
iwr "https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/ninja-universal.ps1?t=$ts" `
    -UseBasicParsing | iex
```

2. **No-cache header** (PowerShell 5.x)
```powershell
# Remove any old script
Remove-Item ninja-universal.ps1 -ErrorAction SilentlyContinue

# Download fresh copy with no-cache header
iwr https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/ninja-universal.ps1 `
    -UseBasicParsing `
    -Headers @{ 'Cache-Control' = 'no-cache' } `
    -OutFile ninja-universal.ps1

# Run with your API credentials
.\
ninja-universal.ps1 -ClientId 'YOUR_ID' -ClientSecret 'YOUR_SECRET' -Install
```

Or with **curl** in Bash/sh (pipe directly to PowerShell):
```bash
curl -H 'Cache-Control: no-cache' -sSL \
  https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/ninja-universal.ps1 | \
  pwsh -c - -ClientId 'YOUR_ID' -ClientSecret 'YOUR_SECRET' -Install
```

#### One‑liner on Windows

If you really need a single line in a Windows PowerShell prompt (no intermediate file), you can download to a temp file and immediately invoke it:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "
    $t = [IO.Path]::Combine([IO.Path]::GetTempPath(), 'ninja-universal.ps1');
    Invoke-WebRequest 'https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/ninja-universal.ps1' \
        -UseBasicParsing -Headers @{ 'Cache-Control' = 'no-cache' } -OutFile $t;
    & $t -ClientId 'YOUR_ID' -ClientSecret 'YOUR_SECRET' -Install
"
```

### Sample: Persisted env vars + download + run (Windows PowerShell)

Below is an example PowerShell session that sets environment variables for your NinjaOne API credentials, downloads the script, and runs the installer using those vars:
```powershell
# Persist credentials for current session (or use SetX for permanent)
$Env:NINJA_CLIENT_ID     = 'YOUR_ID'
$Env:NINJA_CLIENT_SECRET = 'YOUR_SECRET'

# Download latest script
Remove-Item ninja-universal.ps1 -ErrorAction SilentlyContinue
iwr https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/ninja-universal.ps1 \
    -UseBasicParsing -OutFile ninja-universal.ps1

# Run installer (uses env vars, default region NA)
.
ninja-universal.ps1 -Region NA -Install
```

### One‑liner with env vars and no-cache (Windows PowerShell)

To set your API creds, bypass cache, and run in one pipe without printing the script text, use:
```powershell
$Env:NINJA_CLIENT_ID     = 'YOUR_ID'; $Env:NINJA_CLIENT_SECRET = 'YOUR_SECRET'
iex (iwr https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/ninja-universal.ps1 \
    -UseBasicParsing -Headers @{ 'Cache-Control' = 'no-cache' }).Content;
# Then invoke the installer against the US region:
.\n+ninja-universal.ps1 -Region NA -Install
```


## Parameters

| Parameter       | Description                                                        | Default |
| --------------- | ------------------------------------------------------------------ | ------- |
| `-Install`      | Install the agent after downloading                                | `false` |
| `-Gui`          | Force-install GUI libraries on Linux                               | auto    |
| `-NoGui`        | Force-skip GUI libraries on Linux                                  | auto    |
| `-Region`       | Tenant region/instance (`US`, `US2`, `CA`, `EU`, `OC`)           | `US`    |
| `-InstallerType`| Installer type (`WINDOWS_MSI`,`LINUX_DEB`,`LINUX_RPM`,`MAC_PKG`)    | auto    |
| `-ClientId`     | NinjaOne API client Id                                             |         |
| `-ClientSecret` | NinjaOne API client secret                                         |         |

## Troubleshooting

- On Windows PowerShell 5.x, you may need TLS 1.2 support:
  ```powershell
  [Net.ServicePointManager]::SecurityProtocol = 'Tls12'
  ```
- If GUI libraries fail on Linux, retry with `-NoGui` to skip GUI dependencies.
-- If you see "No organisations found.", verify your API credentials and region/instance:
  ```powershell
  # Check module parameters
  Get-Command Connect-NinjaOne | Select-Object -ExpandProperty Parameters

  # Try manual connect and list orgs
  $Env:NINJA_CLIENT_ID     = 'YOUR_ID'
  $Env:NINJA_CLIENT_SECRET = 'YOUR_SECRET'
  Connect-NinjaOne -ClientId $Env:NINJA_CLIENT_ID -ClientSecret $Env:NINJA_CLIENT_SECRET `
    -Instance US -UseClientAuth -Scopes management
  Get-NinjaOneOrganizations

  # Now list and pick an organisation and location interactively:
  $orgs = Get-NinjaOneOrganizations | Sort-Object Name
  for ($i=0; $i -lt $orgs.Count; $i++) { "{0}) {1}" -f $i, $orgs[$i].Name }
  $idx = Read-Host "Select organisation (0-$($orgs.Count-1))"
  $org = $orgs[$idx]

  $locs = Get-NinjaOneLocations -OrganizationId $org.Id | Sort-Object Name
  for ($i=0; $i -lt $locs.Count; $i++) { "{0}) {1}" -f $i, $locs[$i].Name }
  $idx = Read-Host "Select location (0-$($locs.Count-1))"
  $loc = $locs[$idx]
  ```

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release notes and version history.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines and development setup.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
