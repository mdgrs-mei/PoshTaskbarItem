Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

Describe "New-TaskbarItemJumpTask" {
    It "should store basic parameters" {
        $params = @{
            Title = "Test Title"
            Description = "Test Description"
            ApplicationPath = "D:\testapp.exe"
            Arguments = "-TestArg"
            WorkingDirectory = "D:\"
            CustomCategory = "Test Category"
        }
        $jumpTask = New-TaskbarItemJumpTask @params

        $jumpTask.JumpTask.Title | Should -Be $params.Title
        $jumpTask.JumpTask.Description | Should -Be $params.Description
        $jumpTask.JumpTask.ApplicationPath | Should -Be $params.ApplicationPath
        $jumpTask.JumpTask.Arguments | Should -Be $params.Arguments
        $jumpTask.JumpTask.WorkingDirectory | Should -Be $params.WorkingDirectory
        $jumpTask.JumpTask.CustomCategory | Should -Be $params.CustomCategory
    }
    
    It "should support icon resources in PATH env variable" {
        $imageresFullPath = (Get-Command -Type Application imageres.dll).Source
        $iconResourceIndex = 5
        $jumpTask = New-TaskbarItemJumpTask -IconResourcePath imageres.dll -IconResourceIndex $iconResourceIndex

        $jumpTask.JumpTask.IconResourcePath | Should -Be $imageresFullPath
        $jumpTask.JumpTask.IconResourceIndex | Should -Be $iconResourceIndex
    }

    It "should support icon image files" {
        $imagePath = (Resolve-Path "$PSScriptRoot\..\Icons\TestIcon1.png").Path
        $icoPath = [IO.Path]::ChangeExtension($imagePath, ".ico")
        $jumpTask = New-TaskbarItemJumpTask -IconResourcePath $imagePath

        $jumpTask.JumpTask.IconResourcePath | Should -Be $icoPath

        Remove-Item $icoPath -Force
    }

    It "should support ico files" {
        $icoPath = (Resolve-Path "$PSScriptRoot\..\Icons\TestIcon2.ico").Path
        $jumpTask = New-TaskbarItemJumpTask -IconResourcePath $icoPath

        $jumpTask.JumpTask.IconResourcePath | Should -Be $icoPath
    }
}
