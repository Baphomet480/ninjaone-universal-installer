Describe 'ninja-universal.ps1 script' {
    It 'Should display help information' {
        $help = Get-Help "$PSScriptRoot/../ninja-universal.ps1" -Full -ErrorAction SilentlyContinue
        $help | Should -Not -BeNullOrEmpty
    }

    It 'Should declare a valid .VERSION header' {
        $content = Get-Content "$PSScriptRoot/../ninja-universal.ps1" -Raw
        $m = [regex]::Match($content, '(?m)^\s*\.VERSION\s*([0-9]+\.[0-9]+\.[0-9]+)\s*$')
        $m.Success | Should -BeTrue
        $m.Groups[1].Value | Should -Match '^[0-9]+\.[0-9]+\.[0-9]+$'
    }
}
