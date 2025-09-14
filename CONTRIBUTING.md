# Contributing

Thank you for your interest in contributing to the NinjaOne Universal Installer!

## Development setup
1. Fork the repository and clone your fork.
2. Install PowerShell 7+ (`pwsh`).
3. (Optional) Install PSScriptAnalyzer for linting:
   ```powershell
   Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
   ```

## Code style
- Follow PowerShell best practices and PSScriptAnalyzer rules.
- Run `Invoke-ScriptAnalyzer -Path . -Recurse` and address any issues.
- Use Verb-Noun for functions, clear parameter names, and `ValidateSet` where practical.

## Pull Requests
- Create a feature branch from `main`.
- Use Conventional Commits in titles (e.g., `feat:`, `fix:`, `docs:`).
- Ensure your changes include tests if applicable (Pester v5 in `tests/`).
- Update documentation as needed (README parameter table, examples, CHANGELOG).
- For user-facing changes, bump versions in `ninja-universal.ps1` and module manifest.
- Ensure CI is passing before submitting a PR.

## Running
- Local run: `pwsh -File ./ninja-universal.ps1 -Install -ClientId '<ID>' -ClientSecret '<SECRET>'`.
- In CI, prefer structured output: add `-Output Json` and parse with `jq`.
- Linux bootstrap: `sudo bash ./install-ninja.sh -- -Install -ClientId '<ID>' -ClientSecret '<SECRET>'`.

## Release process
- Create `release/x.y.z` branch, bump versions and CHANGELOG, open PR.
- Tag `vX.Y.Z` and push. 
- Until the auto-release workflow lands (#10), publish the GitHub Release manually (e.g., `gh release create vX.Y.Z -F CHANGELOG excerpt`).
- After (#10) is merged, pushing the tag will auto-create/edit the Release.
