Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

Describe 'New-TaskbarItemThumbButton' {
    It 'should store parameters' {
        $params = @{
            Description = 'Test Description'
            IconResourcePath = 'imageres.dll'
            IconResourceIndex = 5
            OnClicked = {}
            KeepOpenWhenClicked = $true
            HideBackground = $true
        }
        $thumbButton = New-TaskbarItemThumbButton @params

        $thumbButton.ThumbButtonInfo.Description | Should -Be $params.Description
        $thumbButton.ThumbButtonInfo.DismissWhenClicked | Should -Be (-not $params.KeepOpenWhenClicked)
        $thumbButton.ThumbButtonInfo.IsBackgroundVisible | Should -Be (-not $params.HideBackground)
        $thumbButton.ThumbButtonInfo.ImageSource | Should -Not -BeNullOrEmpty
        $thumbButton.ThumbButtonInfo.Command | Should -Not -BeNullOrEmpty
    }
}
