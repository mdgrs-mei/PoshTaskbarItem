<#
.SYNOPSIS
Sets a function called periodically.

.DESCRIPTION
Sets a function called periodically while the taskbar item is shown. The function is called on the UI thread and it should not do anything that takes long time to complete not to block the user interaction.

.PARAMETER InputObject
TaskbarItem object.

.PARAMETER ScriptBlock
ScriptBlock to be executed.

.PARAMETER IntervalInMillisecond
Interval millisecond where the function is called. The function is not guaranteed to be executed exactly when the time interval occurs, but it is guaranteed to not be executed before the time interval occurs.

.INPUTS
PSCustomObject. An object that represents a TaskbarItem.

.OUTPUTS
None.

.EXAMPLE
$taskbarItem = New-TaskbarItem
Set-TaskbarItemTimerFunction -InputObject $taskbarItem -ScriptBlock {Write-Host 'Hello'} -IntervalInMillisecond 1000

#>
function Set-TaskbarItemTimerFunction
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
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
