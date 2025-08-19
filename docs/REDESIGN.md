# NinjaOne Universal Installer — Redesign (v1)

## Goals
- Clear, predictable CLI with interactive and headless modes.
- Split monolithic script into reusable module + thin entry script.
- Strong error handling, idempotent installs, and safe uninstalls.
- First-class logging (`-Verbose`, `-InformationAction`, `-WhatIf/-Confirm`).
- Cross-Platform: Win PS5.1 compatible and PS7+ primary.
- CI-friendly: non-interactive flags, JSON output option.

## Proposed Structure
- `src/NinjaUniversal/`
  - `NinjaUniversal.psd1` (manifest)
  - `NinjaUniversal.psm1` (exported functions)
- `ninja-universal.ps1` (thin wrapper / CLI entry)
- `tests/` (Pester v5; focused specs per exported function)
- `docs/` (this redesign doc; usage examples)

## Public Functions (initial set)
- `Install-RequiredModule` — ensure PSGallery modules.
- `Start-Elevation` — relaunch elevated (Windows only).
- `Get-NinjaAuth` — acquire auth (client creds or interactive).
- `Select-NinjaOrganization` / `Select-NinjaLocation` — selection helpers.
- `Get-NinjaInstallerLink` — compute URL for desired installer type.
- `Invoke-NinjaInstall` — perform OS-specific install steps.
- `Remove-NinjaAgent` — safe prior-agent removal (per platform).

## CLI UX (entry script)
- Parameters grouped into sets:
  - Auth: `-ClientId`, `-ClientSecret` | Interactive: none needed.
  - Target: `-Organization`, `-Location`, `-NonInteractive`.
  - Install: `-Install` (default), `-Gui`, `-NoGui`, `-InstallerType`.
  - Output: `-Output (Text|Json)`, `-Verbose`, `-WhatIf`.
- Behavior:
  - Default `-Install` true when omitted.
  - If creds missing and not `-NonInteractive`, use web auth.
  - If multiple matches and `-NonInteractive`, error out.

## Migration Plan
1) Introduce module skeleton + wrapper import (no behavior change).
2) Move helpers: module management, selection, elevation.
3) Move auth + download; return objects; wrapper renders output.
4) Move install logic with `-WhatIf` support and idempotency.
5) Expand tests; update README; tag release.

## Open Questions
- Add device-code auth as headless alternative to web auth?
- Default output to JSON in CI? (detect via `-NonInteractive`?)
- Keep PS5-specific paths inside module, hide in wrapper?

