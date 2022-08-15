<#
.SYNOPSIS
Adds a ThumbButton to a TaskbarItem.

.DESCRIPTION
Adds a ThumbButton created by New-TaskbarItemThumbButton to a TaskbarItem.

.PARAMETER InputObject
TaskbarItem object.

.PARAMETER ThumbButton
ThumbButton that is added to the TaskbarItem.

.INPUTS
PSCustomObject. An object that represents a TaskbarItem.

.OUTPUTS
None.

.EXAMPLE
$taskbarItem = New-TaskbarItem
$thumbButton = New-TaskbarItemThumbButton -Description "Open Folder" -IconResourcePath imageres.dll -IconResourceIndex 3 -OnClicked {explorer.exe /root,D:\}
Add-TaskbarItemThumbButton -InputObject $taskbarItem -ThumbButton $thumbButton

#>
function Add-TaskbarItemThumbButton
{
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [PSCustomObject]$InputObject,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [PSCustomObject]$ThumbButton
    )

    process
    {
        $InputObject.Window.TaskbarItemInfo.ThumbButtonInfos.Add($ThumbButton.ThumbButtonInfo)
    }
}
