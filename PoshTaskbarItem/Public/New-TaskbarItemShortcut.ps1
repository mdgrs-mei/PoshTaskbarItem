<#
.SYNOPSIS
Creates a shortcut to an application.

.DESCRIPTION
Creates a shortcut to an application. This is usually used to create a shortcut to the script that uses PoshTaskbarItem. By creating a shortcut, you can specify the icon shown in the taskbar.

.PARAMETER Path
Path to the saved shortcut (.lnk) file.

.PARAMETER IconResourcePath
File path to the icon resource that is used as a shortcut icon.

.PARAMETER IconResourceIndex
Index of the icon resource that is used in case the icon resource has multiple icon files.

.PARAMETER TargetPath
Path to the application.

.PARAMETER Arguments
Arguments passed to the application.

.PARAMETER WorkingDirectory
Working directory of the application.

.PARAMETER WindowStyle
WindowStyle of the application launched by this shortcut. The value must be "NormalWindow", "Maximized" or "Minimized".

.INPUTS
None.

.OUTPUTS
None.

.EXAMPLE
New-TaskbarItemShortcut -Path "D:\app.lnk" -IconResourcePath "imageres.dll" -IconResourceIndex 15 -TargetPath "powershell.exe" -Arguments '-ExecutionPolicy Bypass -WindowStyle Hidden -File "D:\app.ps1"' -WorkingDirectory "D:\" -WindowStyle "Minimized"

.LINK
This command uses WshShortcut object internally:
https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/xk6kst2k(v=vs.84)

#>
function New-TaskbarItemShortcut
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$Path,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$IconResourcePath,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Int]$IconResourceIndex = 0,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$TargetPath = "powershell.exe",

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Arguments,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$WorkingDirectory,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ValidateSet("NormalWindow", "Maximized", "Minimized")]
        [String]$WindowStyle = "Minimized"
    )

    process
    {
        $wshWindowStyle = switch ($WindowStyle)
        {
            "NormalWindow" {1}
            "Maximized" {3}
            "Minimized" {7}
        }

        # https://docs.microsoft.com/en-us/troubleshoot/windows-client/admin-development/create-desktop-shortcut-with-wsh
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($Path)
        $shortcut.TargetPath = $TargetPath
        $shortcut.Arguments = $Arguments
        $shortcut.WorkingDirectory = $WorkingDirectory
        $shortcut.WindowStyle = $wshWindowStyle

        if ($IconResourcePath)
        {
            $iconResourceFullPath = GetIconResourceFullPath $IconResourcePath
            $shortcut.IconLocation = "$iconResourceFullPath,$IconResourceIndex"
        }

        $shortcut.Save()
    }
}
