<#
.SYNOPSIS
Creates a JumpTask.

.DESCRIPTION
Creates a JumpTask that represents a shortcut to an application in the Windows taskbar Jump List.

.PARAMETER Title
Title text displayed for the task in the Jump List.

.PARAMETER Description
Description text displayed in the tooltip for the task.

.PARAMETER IconResourcePath
File path to the icon resource that is used for the task.

.PARAMETER IconResourceIndex
Index of the icon resource that is used in case the icon resource has multiple icon files.

.PARAMETER ApplicationPath
Path to the application. If this is not set, the path of the current running process is used.

.PARAMETER Arguments
Arguments passed to the application.

.PARAMETER WorkingDirectory
Working directory of the application.

.PARAMETER CustomCategory
Name of the category the JumpItem is grouped with in the Jump List.

.INPUTS
None.

.OUTPUTS
PSCustomObject. An object that represents a JumpTask.

.EXAMPLE
$jumpTask = New-TaskbarItemJumpTask -Title 'Notepad' -Description 'Open Notepad' -IconResourcePath 'notepad.exe' -ApplicationPath 'notepad.exe' -Arguments 'D:\test.txt'

.LINK
https://docs.microsoft.com/en-us/dotnet/api/system.windows.shell.jumptask

#>
function New-TaskbarItemJumpTask
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Title,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Description,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$IconResourcePath,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Int]$IconResourceIndex = 0,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$ApplicationPath,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Arguments,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$WorkingDirectory,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$CustomCategory
    )

    process
    {
        $shellJumpTask = New-Object System.Windows.Shell.JumpTask
        $shellJumpTask.Title = $Title
        $shellJumpTask.Description = $Description
        $shellJumpTask.ApplicationPath = $ApplicationPath
        $shellJumpTask.Arguments = $Arguments
        $shellJumpTask.WorkingDirectory = $WorkingDirectory
        $shellJumpTask.CustomCategory = $CustomCategory

        if ($IconResourcePath)
        {
            $iconResourceFullPath = GetIconResourceFullPath $IconResourcePath
            $shellJumpTask.IconResourcePath = $iconResourceFullPath
            $shellJumpTask.IconResourceIndex = $IconResourceIndex
        }

        $jumpTask = [PSCustomObject]@{
            JumpTask = $shellJumpTask
        }
        $jumpTask
    }
}
