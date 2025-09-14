@{
    RootModule        = 'NinjaUniversal.psm1'
    ModuleVersion     = '0.2.1'
    GUID              = '3f2e6a0a-53a7-4c7a-8e22-474d24b5b4e2'
    Author            = 'NinjaOne Community'
    CompanyName       = 'NinjaOne'
    Copyright         = '(c) NinjaOne. All rights reserved.'
    Description       = 'Reusable functions for the NinjaOne Universal Installer.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'Install-RequiredModule',
        'Start-Elevation',
        'Get-NinjaAuth',
        'Select-NinjaOrganization',
        'Select-NinjaLocation',
        'Get-NinjaInstallerLink',
        'Invoke-NinjaInstall',
        'Remove-NinjaAgent'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
