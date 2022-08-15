Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

Describe "New-TaskbarItem" {
    It "should store basic parameters" {
        $title = "Test Title"
        $onClicked = {}
        $ti = New-TaskbarItem -Title $title -OnClicked $onClicked

        $ti.Window | Should -Not -BeNullOrEmpty
        $ti.Window.Title | Should -Be $title
        $ti.OnClicked | Should -Be $onClicked
    }

    It "should support dll icon resource" {
        $ti = New-TaskbarItem -IconResourcePath imageres.dll -IconResourceIndex 5

        $ti.Window | Should -Not -BeNullOrEmpty
        $ti.Window.Icon | Should -Not -BeNullOrEmpty
    }

    It "should support icon image files" {
        $ti = New-TaskbarItem -IconResourcePath "$PSScriptRoot\..\Icons\TestIcon1.png"

        $ti.Window | Should -Not -BeNullOrEmpty
        $ti.Window.Icon | Should -Not -BeNullOrEmpty
    }

    It "should support ico files" {
        $ti = New-TaskbarItem -IconResourcePath "$PSScriptRoot\..\Icons\TestIcon2.ico"

        $ti.Window | Should -Not -BeNullOrEmpty
        $ti.Window.Icon | Should -Not -BeNullOrEmpty
    }
}
