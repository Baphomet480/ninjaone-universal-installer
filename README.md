# NinjaOne Universal Installer
**Version: 0.2.0**

A single, self-contained PowerShell script that:

- Authenticates to the NinjaOne Public API v2
- Lets you pick Organization → Location interactively
- Downloads the latest agent build for that location
- Optionally installs the agent (handles elevation, removes older versions)
- Adds GUI/OpenGL libraries on Linux workstations when needed

Runs on Windows PowerShell 5.x and PowerShell 7+ across Windows, Ubuntu, Rocky/Alma, macOS (with `pwsh`).

---

## Quick Start

### Linux/macOS (recommended)
Download the wrapper (preserves interactive prompts) and run:
```bash
curl -sSL https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/install-ninja.sh -o install-ninja.sh
sudo bash install-ninja.sh -- -Install -ClientId '<CLIENT_ID>' -ClientSecret '<CLIENT_SECRET>'
```

One-liner (convenient; some sudo/TTY setups limit prompts):
```bash
curl -sSL "https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/install-ninja.sh?$(date +%s)" | \
  sudo bash -s -- -Install -ClientId '<CLIENT_ID>' -ClientSecret '<CLIENT_SECRET>'
```

### Windows (PowerShell 5.x or 7+)
Download the script (no-cache) and run:
```powershell
Remove-Item .\ninja-universal.ps1 -ErrorAction SilentlyContinue
Invoke-WebRequest https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/ninja-universal.ps1 `
  -UseBasicParsing -Headers @{ 'Cache-Control' = 'no-cache' } -OutFile ninja-universal.ps1
.
ninja-universal.ps1 -Install -ClientId '<CLIENT_ID>' -ClientSecret '<CLIENT_SECRET>'
```

---

## Requirements
- Windows PowerShell 5.x or PowerShell 7+ (`pwsh`).
- Internet access to the NinjaOne API and OS package repositories.

## Obtain API Credentials
1. In NinjaOne, go to Settings → API → API Clients.
2. Add a client and copy the Client Id and Client Secret.
3. Optional: set env vars for convenience:
   ```powershell
   $Env:NINJA_CLIENT_ID     = 'your-client-id'
   $Env:NINJA_CLIENT_SECRET = 'your-client-secret'
   ```

---

## Advanced Usage

### Download only (interactive)
```powershell
./ninja-universal.ps1 -ClientId 'YOUR_ID' -ClientSecret 'YOUR_SECRET'
```

### Download and install (non-interactive)
```powershell
./ninja-universal.ps1 -Install -Organization 'Acme Co' -Location 'HQ' -NonInteractive `
  -ClientId 'YOUR_ID' -ClientSecret 'YOUR_SECRET'
```

### Headless or SSH (device code auth)
```powershell
./ninja-universal.ps1 -Install -UseDeviceCode
```
Notes:
- Prints a verification URL and code to enter on another device.
- If the installed NinjaOne module lacks device-code support, use client credentials instead.

### Direct pipe to PowerShell (optional)
Linux/macOS:
```bash
curl -H 'Cache-Control: no-cache' -sSL \
  https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/ninja-universal.ps1 | \
  pwsh -c - -Install -ClientId 'YOUR_ID' -ClientSecret 'YOUR_SECRET'
```

---

## Installing PowerShell on Linux (optional)
If your distro doesn’t have PowerShell 7, install it with:
```bash
curl -sSL https://raw.githubusercontent.com/baphomet480/ninjaone-universal-installer/main/install-pwsh.sh | sudo bash
```

---

## Parameters

| Parameter         | Description                                                          | Default |
| ----------------- | -------------------------------------------------------------------- | ------- |
| `-Install`        | Install the agent after downloading                                  | `true`  |
| `-Gui`            | Force-install GUI libraries on Linux                                 | auto    |
| `-NoGui`          | Force-skip GUI libraries on Linux                                    | auto    |
| `-Region`         | Tenant region/instance (`US`, `US2`, `CA`, `EU`, `OC`, `NA`)         | `US`    |
| `-InstallerType`  | Installer type (`WINDOWS_MSI`,`LINUX_DEB`,`LINUX_RPM`,`MAC_PKG`)     | auto    |
| `-ClientId`       | NinjaOne API client Id                                               |         |
| `-ClientSecret`   | NinjaOne API client secret                                           |         |
| `-Organization`   | Organization Id or Name (skips interactive pick)                     |         |
| `-Location`       | Location Id or Name (skips interactive pick)                         |         |
| `-NonInteractive` | Fail instead of prompting when selection is ambiguous                | `false` |
| `-UseDeviceCode`  | Force device code auth; auto-used when no GUI is available           | `false` |

---

## Troubleshooting
- PowerShell 5.x TLS: enable TLS 1.2 if downloads fail.
  ```powershell
  [Net.ServicePointManager]::SecurityProtocol = 'Tls12'
  ```
- PSGallery prompts: pre-trust and add NuGet provider.
  ```powershell
  Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
  Install-PackageProvider -Name NuGet -Scope CurrentUser -Force
  ```
- Linux GUI dependencies: if GUI deps fail, rerun with `-NoGui`.
- Empty organisation list: verify API credentials and region/instance.
- Insufficient privileges: client needs `management` and `monitoring` scopes.
- Headless sessions: prefer `-UseDeviceCode` instead of web auth.

---

## Changelog
See [CHANGELOG.md](CHANGELOG.md) for release notes.

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines and development setup.

## License
MIT — see [LICENSE](LICENSE).

## CLI Reference
For detailed NinjaOne cmdlet help, see [NinjaOne-CmdletHelp.md](NinjaOne-CmdletHelp.md).
