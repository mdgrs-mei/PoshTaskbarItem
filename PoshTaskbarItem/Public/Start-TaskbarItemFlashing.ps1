<#
.SYNOPSIS
Flashes a TaskbarItem in the taskbar.

.DESCRIPTION
Flashes a TaskbarItem in the taskbar. Normally you need to call this function from the script block set by Set-TaskbarItemTimerFunction because it's effective only when the TaskbarItem is shown.

.PARAMETER InputObject
TaskbarItem object.

.PARAMETER Count
The number of times the TaskbarItem flashes.

.INPUTS
PSCustomObject. An object that represents a TaskbarItem.

.OUTPUTS
None.

.EXAMPLE
$taskbarItem = New-TaskbarItem
Set-TaskbarItemTimerFunction $taskbarItem -IntervalInMillisecond 10000 -ScriptBlock {
    Start-TaskbarItemFlashing $taskbarItem
}
Show-TaskbarItem $taskbarItem

#>
function Start-TaskbarItemFlashing
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [PSCustomObject]$InputObject,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Int]$Count = 2
    )

    process
    {
        # use default flash rate
        $rateInMillisecond = 0
        FlashWindow $InputObject.MainWindowHandle $rateInMillisecond $Count
    }
}
