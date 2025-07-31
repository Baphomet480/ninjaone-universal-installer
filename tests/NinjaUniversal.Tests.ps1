Describe 'ninja-universal.ps1 script' {
    It 'Should display help information' {
        $help = Get-Help "$PSScriptRoot/../ninja-universal.ps1" -ErrorAction SilentlyContinue
        $help | Should -Not -BeNullOrEmpty
    }
}
