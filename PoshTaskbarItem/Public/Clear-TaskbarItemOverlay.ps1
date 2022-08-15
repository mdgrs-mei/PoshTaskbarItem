<#
.SYNOPSIS
Clears the overlay icon or badge of a TaskbarItem.

.DESCRIPTION
Clears the overlay icon or badge of a TaskbarItem.

.PARAMETER InputObject
TaskbarItem object.

.INPUTS
PSCustomObject. An object that represents a TaskbarItem.

.OUTPUTS
None.

.EXAMPLE
$taskbarItem = New-TaskbarItem
Set-TaskbarItemOverlayBadge $taskbarItem -Text "5"
Clear-TaskbarItemOverlay $taskbarItem

#>
function Clear-TaskbarItemOverlay
{
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [PSCustomObject]$InputObject
    )

    process
    {
        $InputObject.Window.TaskbarItemInfo.Overlay = $null
        $InputObject.OnLoadedForOverlayBadge = $null
    }
}
