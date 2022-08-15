Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

BeforeAll {
    $ti = New-TaskbarItem
}

Describe "Set-TaskbarItemDescription" {
    It "should store description" {
        $description = "Test Description"
        Set-TaskbarItemDescription -InputObject $ti -Description $description

        $ti.Window.TaskbarItemInfo.Description | Should -Be $description
    }
}
