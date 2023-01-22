Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

BeforeAll {
    $ti = New-TaskbarItem
    $thumbButton = New-TaskbarItemThumbButton
}

Describe 'Add-TaskbarItemThumbButton' {
    It 'should store a ThumbButton to TaskbarItem' {
        Add-TaskbarItemThumbButton -InputObject $ti -ThumbButton $thumbButton
        $ti.Window.TaskbarItemInfo.ThumbButtonInfos.Item(0) | Should -Be $thumbButton.ThumbButtonInfo
    }
}
