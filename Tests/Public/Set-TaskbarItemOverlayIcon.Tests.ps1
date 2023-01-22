Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

BeforeAll {
    $ti = New-TaskbarItem
}

Describe 'Set-TaskbarItemOverlayIcon' {
    It 'should support dll icon resource' {
        Set-TaskbarItemOverlayIcon -InputObject $ti -IconResourcePath imageres.dll -IconResourceIndex 5

        $ti.Window.TaskbarItemInfo.Overlay | Should -Not -BeNullOrEmpty
    }

    It 'should support icon image files' {
        Set-TaskbarItemOverlayIcon -InputObject $ti -IconResourcePath "$PSScriptRoot\..\Icons\TestIcon1.png"

        $ti.Window.TaskbarItemInfo.Overlay | Should -Not -BeNullOrEmpty
    }

    It 'should support ico files' {
        Set-TaskbarItemOverlayIcon -InputObject $ti -IconResourcePath "$PSScriptRoot\..\Icons\TestIcon2.ico"

        $ti.Window.TaskbarItemInfo.Overlay | Should -Not -BeNullOrEmpty
    }
}
