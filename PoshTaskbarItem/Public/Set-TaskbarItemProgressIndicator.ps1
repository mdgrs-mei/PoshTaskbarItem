<#
.SYNOPSIS
Sets the progress indicator of a TaskbarItem.

.DESCRIPTION
Sets the progress indicator of a TaskbarItem.

.PARAMETER InputObject
TaskbarItem object.

.PARAMETER Progress
A value that indicates the fullness of the progress indicator in the taskbar button. The value range must be between 0.0 to 1.0. The progress value is used if the State property is Normal, Paused, or Error.

.PARAMETER State
A value that indicates how the progress indicator is displayed in the taskbar button. The value must be one of the following:

- Error : A red progress indicator.
- Indeterminate : A pulsing green indicator.
- None : No progress indicator.
- Normal : A green progress indicator.
- Paused : A yellow progress indicator.

.INPUTS
PSCustomObject. An object that represents a TaskbarItem.

.OUTPUTS
None.

.EXAMPLE
$taskbarItem = New-TaskbarItem
Set-TaskbarItemProgressIndicator $taskbarItem -Progress 0.5 -State Normal

.LINK
https://docs.microsoft.com/en-us/dotnet/api/system.windows.shell.taskbariteminfo.progressvalue

#>
function Set-TaskbarItemProgressIndicator
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [PSCustomObject]$InputObject,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ValidateRange(0.0, 1.0)]
        [Double]$Progress = 0.0,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Error', 'Indeterminate', 'None', 'Normal', 'Paused')]
        [String]$State = 'None'
    )

    process
    {
        $progressState = [System.Windows.Shell.TaskbarItemProgressState]$State

        $InputObject.Window.TaskbarItemInfo.ProgressState = $progressState
        $InputObject.Window.TaskbarItemInfo.ProgressValue = $Progress
    }
}
