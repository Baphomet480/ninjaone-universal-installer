Describe 'ninja-universal.ps1 script' {
    It 'Should display help information' {
        $help = Get-Help "$PSScriptRoot/../ninja-universal.ps1" -Full -ErrorAction SilentlyContinue
        $help | Should -Not -BeNullOrEmpty
    }

    It 'Should include Version: 0.1.0 in the script file header' {
        $scriptText = Get-Content "$PSScriptRoot/../ninja-universal.ps1"
        ($scriptText -join "`n") | Should -Match 'Version: 0\.1\.0'
    }
}
