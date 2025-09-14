# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]
- 

## [0.2.2] - 2025-09-14
- feat(windows): support no-save one-liner (`iwr|iex`) by self-materializing during elevation.
- docs: update Windows section with no-save one-liner and temp-file variant.

## [0.2.1] - 2025-09-14
- fix: robust auth across NinjaOne module versions (param probing, clearer errors).
- feat: auto instance fallback for client credentials (tries US/US2/EU/CA/OC).
- fix: pass scopes as array not comma string.
- tests: add Pester for auth path + fallback.
- docs: clarify interactive auth requiring client credentials in some versions; note env vars; region fallback tip.

## [0.2.0] - 2025-08-19
- feat: non-interactive UX via `-Organization`, `-Location`, `-NonInteractive`.
- feat: default to `-Install` when omitted.
- chore: replace `Write-Host` with `Write-Information`/`Write-Warning`.
- fix: add `SupportsShouldProcess` to uninstall routine; safer uninstalls.
- fix: clear ScriptAnalyzer parse errors; resolve redirection warning.
- docs: update README with new usage; bump version.
