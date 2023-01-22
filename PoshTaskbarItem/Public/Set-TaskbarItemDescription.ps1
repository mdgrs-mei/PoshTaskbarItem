<#
.SYNOPSIS
Sets a description of a TaskbarItem.

.DESCRIPTION
Sets a description of a TaskbarItem that is shown by a mouse over.

.PARAMETER InputObject
TaskbarItem object.

.PARAMETER Description
Description to be set.

.INPUTS
PSCustomObject. An object that represents a TaskbarItem.

.OUTPUTS
None.

.EXAMPLE
$taskbarItem = New-TaskbarItem
Set-TaskbarItemDescription -InputObject $taskbarItem -Description 'This is a description'

#>
function Set-TaskbarItemDescription
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [PSCustomObject]$InputObject,

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [String]$Description
    )

    process
    {
        $InputObject.Window.TaskbarItemInfo.Description = $Description
    }
}
