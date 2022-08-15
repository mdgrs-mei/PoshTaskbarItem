Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

BeforeAll {
    $ti = New-TaskbarItem
}

Describe "Set-TaskbarItemOverlayBadge" {
    It "should set overlay immediately" {
        $ti.MainWindowHandle = 1
        $params = @{
            InputObject = $ti
            Text = "Test Text"
            BadgeSize = 14
            FontSize = 10
            FrameWidth = 1
            BackgroundColor = "Yellow"
            ForegroundColor = "Black"
        }
        Set-TaskbarItemOverlayBadge @params

        $ti.Window.TaskbarItemInfo.Overlay | Should -Not -BeNullOrEmpty
    }

    It "should set callback" {
        $ti.MainWindowHandle = 0
        $params = @{
            InputObject = $ti
            Text = "Test Text"
            BadgeSize = 14
            FontSize = 10
            FrameWidth = 1
            BackgroundColor = "Yellow"
            ForegroundColor = "Black"
        }
        Set-TaskbarItemOverlayBadge @params

        $ti.OnLoadedForOverlayBadge | Should -Not -BeNullOrEmpty
    }
}
