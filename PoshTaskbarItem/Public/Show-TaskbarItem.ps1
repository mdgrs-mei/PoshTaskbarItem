<#
.SYNOPSIS
Shows a TaskbarItem.

.DESCRIPTION
Shows a TaskbarItem and returns when its window is closed. A TaskbarItem can be shown only once.

.PARAMETER InputObject
TaskbarItem object.

.INPUTS
PSCustomObject. An object that represents a TaskbarItem.

.OUTPUTS
None.

.EXAMPLE
$taskbarItem = New-TaskbarItem
Show-TaskbarItem -InputObject $taskbarItem

#>
function Show-TaskbarItem
{
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [PSCustomObject]$InputObject
    )

    process
    {
        $InputObject.Window.ShowDialog() | Out-Null
        if ($InputObject.Timer)
        {
            $InputObject.Timer.Stop()
            $InputObject.Timer = $null
        }
    }
}
