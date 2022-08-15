Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

BeforeAll {
    $ti = New-TaskbarItem
}

Describe "Start-TaskbarItemFlashing" {
    It "should return without any error" {
        Start-TaskbarItemFlashing -InputObject $ti -Count 3
    }
}
