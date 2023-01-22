Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

BeforeAll {
    $ti = New-TaskbarItem
}

Describe 'Set-TaskbarItemTimerFunction' {
    It 'should create a timer' {
        Set-TaskbarItemTimerFunction -InputObject $ti -IntervalInMillisecond 1000 -ScriptBlock {
            'Hi.'
        }

        $ti.Timer | Should -Not -BeNullOrEmpty
    }

    It 'should be able to call twice' {
        Set-TaskbarItemTimerFunction -InputObject $ti -IntervalInMillisecond 1000 -ScriptBlock {
            'Hi.'
        }

        Set-TaskbarItemTimerFunction -InputObject $ti -IntervalInMillisecond 1000 -ScriptBlock {
            'Hi again.'
        }

        $ti.Timer | Should -Not -BeNullOrEmpty
    }
}
