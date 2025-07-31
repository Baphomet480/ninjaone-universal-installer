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

## Pull Requests
- Create a feature branch from `main`.
- Ensure your changes include tests if applicable.
- Update documentation as needed.
- Ensure CI is passing before submitting a PR.
