<#
.SYNOPSIS
Sets the overlay icon of a TaskbarItem.

.DESCRIPTION
Sets the image that is displayed over a TaskbarItem icon in the taskbar. This function and Set-TaskbarItemOverlayBadge sets the same overlay property of a TaskbarItem.

.PARAMETER InputObject
TaskbarItem object.

.PARAMETER IconResourcePath
File path to the icon resource.

.PARAMETER IconResourceIndex
Index of the icon resource that is used in case the icon resource has multiple icon files.

.INPUTS
PSCustomObject. An object that represents a TaskbarItem.

.OUTPUTS
None.

.EXAMPLE
$taskbarItem = New-TaskbarItem
Set-TaskbarItemOverlayIcon $taskbarItem -IconResourcePath shell32.dll -IconResourceIndex 23

.LINK
https://docs.microsoft.com/en-us/dotnet/api/system.windows.shell.taskbariteminfo.overlay

#>
function Set-TaskbarItemOverlayIcon
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [PSCustomObject]$InputObject,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$IconResourcePath,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Int]$IconResourceIndex = 0
    )

    process
    {
        if ($IconResourcePath)
        {
            $InputObject.Window.TaskbarItemInfo.Overlay = GetImageSource $IconResourcePath $IconResourceIndex
        }
    }
}
