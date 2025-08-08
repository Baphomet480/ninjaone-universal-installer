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

## Coding Style & Naming
- PowerShell: follow PSScriptAnalyzer rules; prefer Verb-Noun for functions; use clear parameter names and `ValidateSet` where appropriate.
- Shell: `set -euo pipefail`, explicit checks, and POSIX-friendly conditionals where feasible.
- Indentation: 2–4 spaces (match surrounding file); no tabs.
- Filenames: scripts in kebab-case (`install-ninja.sh`); tests end with `.Tests.ps1`.

## Testing Guidelines
- Framework: Pester (v5). Place specs under `tests/` and name `<Target>.Tests.ps1`.
- Scope: add tests for parsing, option handling, and platform-specific branches when practical.
- Run: `pwsh -c "Invoke-Pester -Path tests"`.
- Aim for meaningful assertions; keep fixtures minimal and OS-agnostic.

## Commit & Pull Requests
- Commits: use Conventional Commits (e.g., `feat:`, `fix:`, `docs:`, `chore:`). Example: `fix: purge old agent packages before deb install`.
- Branches: short, descriptive (e.g., `feat/linux-gui-libs`, `fix/windows-msi-removal`).
- PRs: include summary, rationale, test results, and screenshots/logs when relevant. Link issues, update docs, and ensure CI passes.

## Security & Configuration
- Never commit credentials. Use environment variables `NINJA_CLIENT_ID` and `NINJA_CLIENT_SECRET` for local testing.
- Prefer cache-busting headers/queries when fetching scripts externally to avoid stale copies (see README examples).

## Notes for Contributors
- Target Windows PowerShell 5.x compatibility where noted and PowerShell 7+ as primary dev environment.
- Keep changes focused; avoid distro-specific assumptions if a generic path exists.
