<#
.SYNOPSIS
Adds a JumpTask to a TaskbarItem.

.DESCRIPTION
Adds a JumpTask created by New-TaskbarItemJumpTask to a TaskbarItem.

.PARAMETER InputObject
TaskbarItem object.

.PARAMETER JumpTask
JumpTask that is added to the TaskbarItem.

.INPUTS
PSCustomObject. An object that represents a TaskbarItem.

.OUTPUTS
None.

.EXAMPLE
$taskbarItem = New-TaskbarItem
$jumpTask = New-TaskbarItemJumpTask -Title "JumpTask"
Add-TaskbarItemJumpTask -InputObject $taskbarItem -JumpTask $jumpTask

#>
function Add-TaskbarItemJumpTask
{
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [PSCustomObject]$InputObject,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [PSCustomObject]$JumpTask
    )

    process
    {
        $InputObject.JumpList.JumpItems.Add($JumpTask.JumpTask)
        $InputObject.JumpList.Apply()
    }
}
