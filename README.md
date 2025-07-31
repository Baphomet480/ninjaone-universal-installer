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
