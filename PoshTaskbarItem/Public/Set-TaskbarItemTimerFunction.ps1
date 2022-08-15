<#
.SYNOPSIS
Sets a function called repeatedly.

.DESCRIPTION
Sets a function called repeatedly while the taskbar item is shown.

.PARAMETER InputObject
TaskbarItem object.

.PARAMETER ScriptBlock
ScriptBlock to be executed. The script block is called in the UI thread.

.PARAMETER IntervalInMillisecond
Interval millisecond where the script block is called.

.INPUTS
PSCustomObject. An object that represents a TaskbarItem.

.OUTPUTS
None.

.EXAMPLE
$taskbarItem = New-TaskbarItem
Set-TaskbarItemTimerFunction -InputObject $taskbarItem -ScriptBlock {Write-Host "Hello"} -IntervalInMillisecond 1000

#>
function Set-TaskbarItemTimerFunction
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [PSCustomObject]$InputObject,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Int]$IntervalInMillisecond,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ScriptBlock]$ScriptBlock
    )

    process
    {
        if ($InputObject.Timer)
        {
            $InputObject.Timer.Stop()
        }

        $InputObject.Timer = New-Object System.Windows.Threading.DispatcherTimer
        $InputObject.Timer.Interval = [System.TimeSpan]::FromMilliseconds($IntervalInMillisecond)
        $InputObject.Timer.add_Tick($ScriptBlock)
        $InputObject.Timer.Start()
    }
}
