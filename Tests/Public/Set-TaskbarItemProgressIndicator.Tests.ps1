Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

BeforeAll {
    $ti = New-TaskbarItem
}

Describe "Set-TaskbarItemProgressIndicator" {
    It "should store progress information" {
        $progress = 0.5
        $state = "Error"
        Set-TaskbarItemProgressIndicator -InputObject $ti -Progress $progress -State $state

        $ti.Window.TaskbarItemInfo.ProgressValue | Should -Be $progress
        $ti.Window.TaskbarItemInfo.ProgressState | Should -Be $state
    }
}
