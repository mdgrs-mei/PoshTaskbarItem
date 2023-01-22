Import-Module $PSScriptRoot\..\..\PoshTaskbarItem -Force

Describe 'New-TaskbarItemShortcut' {
    It 'should save lnk file with given parameters' {
        $imageresFullPath = (Get-Command -Type Application imageres.dll).Source
        $params = @{
            Path = "$PSScriptRoot\test.lnk"
            IconResourcePath = $imageresFullPath
            IconResourceIndex = 5
            TargetPath = 'D:\testapp.exe'
            Arguments = '-TestArg'
            WorkingDirectory = 'D:\'
            WindowStyle = 'NormalWindow'
        }
        New-TaskbarItemShortcut @params

        $iconLocation = '{0},{1}' -f $params.IconResourcePath, $params.IconResourceIndex
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($params.Path)

        $shortcut.TargetPath | Should -Be $params.TargetPath
        $shortcut.Arguments | Should -Be $params.Arguments
        $shortcut.WorkingDirectory | Should -Be $params.WorkingDirectory
        $shortcut.WindowStyle | Should -Be 1 # NormalWindow
        $shortcut.IconLocation | Should -Be $iconLocation

        Remove-Item $params.Path -Force
    }
}
