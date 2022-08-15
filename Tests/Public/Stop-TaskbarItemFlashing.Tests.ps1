Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

BeforeAll {
    $ti = New-TaskbarItem
}

Describe "Stop-TaskbarItemFlashing" {
    It "should return without any error" {
        Stop-TaskbarItemFlashing -InputObject $ti
    }
}
