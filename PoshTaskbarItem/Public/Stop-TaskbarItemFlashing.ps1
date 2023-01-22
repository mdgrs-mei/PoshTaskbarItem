<#
.SYNOPSIS
Stops the flashing of a TaskbarItem in the taskbar.

.DESCRIPTION
Stops the flashing of a TaskbarItem in the taskbar. Normally you need to call this function from the script block set by Set-TaskbarItemTimerFunction because it's effective only when the TaskbarItem is shown.

.PARAMETER InputObject
TaskbarItem object.

.INPUTS
PSCustomObject. An object that represents a TaskbarItem.

.OUTPUTS
None.

.EXAMPLE
$taskbarItem = New-TaskbarItem
$count = 0
Set-TaskbarItemTimerFunction $taskbarItem -IntervalInMillisecond 5000 -ScriptBlock {
    if ($count % 2 -eq 0)
    {
        Start-TaskbarItemFlashing $taskbarItem
    }
    else
    {
        Stop-TaskbarItemFlashing $taskbarItem
    }
    $count++
}
Show-TaskbarItem $taskbarItem

#>
function Stop-TaskbarItemFlashing
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [PSCustomObject]$InputObject
    )

    process
    {
        $InputObject.SkipOnClicked = $true
        ShowWindow $InputObject.MainWindowHandle
    }
}
