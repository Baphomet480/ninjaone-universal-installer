# Repository Guidelines

## Project Structure & Modules
- Root scripts: `ninja-universal.ps1` (PowerShell installer), `install-ninja.sh` and `install-pwsh.sh` (Linux bootstrap/helpers).
- Tests: `tests/` with Pester specs (e.g., `NinjaUniversal.Tests.ps1`).
- Docs: `README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, `NinjaOne-CmdletHelp.md`.

## Build, Test, and Development
- Run locally (PowerShell 7+): `pwsh -File ./ninja-universal.ps1 -Install -ClientId '<ID>' -ClientSecret '<SECRET>'`.
- Lint PowerShell: `pwsh -c "Invoke-ScriptAnalyzer -Path . -Recurse"`.
- Run tests: `pwsh -c "Invoke-Pester -Path tests"`.
- Linux bootstrap + run: `sudo bash ./install-ninja.sh -- -Install -ClientId '<ID>' -ClientSecret '<SECRET>'`.
CI mirrors lint and test via GitHub Actions.

### CLI/CI conventions
- Default behavior installs the agent when `-Install` is omitted.
- Prefer `-Output Json` in CI to capture structured results.
- Supported env vars: `NINJA_CLIENT_ID`, `NINJA_CLIENT_SECRET`, optional `NINJA_REFRESH_TOKEN`.
 - Planned (#4): `-LogPath` and standardized exit codes for CI; update docs when merged.

### Release checklist
When shipping a user-facing change (flags, behavior, messages):
- Bump versions in `ninja-universal.ps1` and `src/NinjaUniversal/NinjaUniversal.psd1`.
- Update README (Quick Start, parameter table, Windows one‑liner if applicable).
- Add/adjust Pester tests under `tests/` to cover new behavior.
- Update `CHANGELOG.md` with date and summary.
- Open `release/x.y.z` PR, tag `vX.Y.Z`, and publish GitHub Release notes.
 - Planned (#10): tag push `v*` auto-publishes Release via workflow; remove manual step once merged.

## Coding Style & Naming
- PowerShell: follow PSScriptAnalyzer rules; prefer Verb-Noun for functions; use clear parameter names and `ValidateSet` where appropriate.
- Shell: `set -euo pipefail`, explicit checks, and POSIX-friendly conditionals where feasible.
- Indentation: 2–4 spaces (match surrounding file); no tabs.
- Filenames: scripts in kebab-case (`install-ninja.sh`); tests end with `.Tests.ps1`.
 - When adding CLI parameters, include help in the comment-based help block and update README’s parameter table.

## Testing Guidelines
- Framework: Pester (v5). Place specs under `tests/` and name `<Target>.Tests.ps1`.
- Scope: add tests for parsing, option handling, and platform-specific branches when practical.
- Run: `pwsh -c "Invoke-Pester -Path tests"`.
- Aim for meaningful assertions; keep fixtures minimal and OS-agnostic.
 - For auth flows: prefer mocks to avoid real API calls; cover region fallback and device-code/web-auth selection logic.

## Commit & Pull Requests
- Commits: use Conventional Commits (e.g., `feat:`, `fix:`, `docs:`, `chore:`). Example: `fix: purge old agent packages before deb install`.
- Branches: short, descriptive (e.g., `feat/linux-gui-libs`, `fix/windows-msi-removal`).
- PRs: include summary, rationale, test results, and screenshots/logs when relevant. Link issues, update docs, and ensure CI passes.
 - For release PRs, link to the tag and include the CHANGELOG excerpt.

## Security & Configuration
- Never commit credentials. Use environment variables `NINJA_CLIENT_ID` and `NINJA_CLIENT_SECRET` for local testing.
- Prefer cache-busting headers/queries when fetching scripts externally to avoid stale copies (see README examples).
 - Some NinjaOne module versions require ClientId/ClientSecret even for interactive auth; document this when changing auth behavior.

## Notes for Contributors
- Target Windows PowerShell 5.x compatibility where noted and PowerShell 7+ as primary dev environment.
- Keep changes focused; avoid distro-specific assumptions if a generic path exists.
