Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

BeforeAll {
    $ti = New-TaskbarItem
    $jumpTask = New-TaskbarItemJumpTask -Title $testString
}

Describe 'Add-TaskbarItemJumpTask' {
    It 'should store a JumpTask to TaskbarItem' {
        Add-TaskbarItemJumpTask -InputObject $ti -JumpTask $jumpTask
        $ti.JumpList.JumpItems.Item(0) | Should -Be $jumpTask.JumpTask
    }
}
