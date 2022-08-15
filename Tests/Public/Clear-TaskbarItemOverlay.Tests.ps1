Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

BeforeAll {
    $ti = New-TaskbarItem
    Set-TaskbarItemOverlayBadge $ti
}

Describe "Clear-TaskbarItemOverlay" {
    It "should clear overlay and callback" {
        Clear-TaskbarItemOverlay -InputObject $ti
        $ti.Window.TaskbarItemInfo.Overlay | Should -BeNullOrEmpty
        $ti.Window.TaskbarItemInfo.OnLoadedForOverlayBadge | Should -BeNullOrEmpty
    }
}
