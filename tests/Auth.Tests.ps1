Describe 'Get-NinjaAuth (module)' {
    BeforeAll {
        Import-Module "$PSScriptRoot/../src/NinjaUniversal/NinjaUniversal.psd1" -Force
    }

    Context 'Client credentials' {
        BeforeEach {
            $global:__connectArgs = $null
            InModuleScope NinjaUniversal {
                Mock -CommandName Connect-NinjaOne -MockWith {
                    param()
                    $global:__connectArgs = $PSBoundParameters
                }
            }
        }

        It 'Maps NA to US and returns Mode=Client' {
            $result = InModuleScope NinjaUniversal { Get-NinjaAuth -Region NA -ClientId 'id' -ClientSecret 'secret' }
            $result.Mode   | Should -Be 'Client'
            $result.Region | Should -Be 'US'
        }

        It 'Auto-falls back to a working instance when first fails' {
            # Fail for 'us', succeed for 'eu'
            InModuleScope NinjaUniversal {
                $script:last = $null
                Mock -CommandName Connect-NinjaOne -ParameterFilter { $PSBoundParameters['Instance'] -eq 'us' -or $PSBoundParameters['Region'] -eq 'us' -or $PSBoundParameters['Environment'] -eq 'us' } -MockWith {
                    throw [System.Exception]::new('404 Not Found')
                }
                Mock -CommandName Connect-NinjaOne -MockWith {
                    param()
                    $script:last = $PSBoundParameters
                }
                $res = Get-NinjaAuth -Region US -ClientId 'id' -ClientSecret 'secret'
                $res.Mode | Should -Be 'Client'
                $script:last | Should -Not -BeNullOrEmpty
            }
        }
    }
}
