<#
.SYNOPSIS
Creates a ThumbButton.

.DESCRIPTION
Creates a ThumbButton that is displayed in the Windows taskbar thumbnail.

.PARAMETER Description
Description text displayed in the tooltip for the thumbnail button.

.PARAMETER IconResourcePath
File path to the icon resource that is used for the button.

.PARAMETER IconResourceIndex
Index of the icon resource that is used in case the icon resource has multiple icon files.

.PARAMETER OnClicked
ScriptBlock that is executed when the button is clicked. The script block is called in the UI thread.

.PARAMETER KeepOpenWhenClicked
Switch to keep the taskbar thumbnail open when the button is clicked.

.PARAMETER HideBackground
Switch to hide the border and highlight of the button.

.INPUTS
None.

.OUTPUTS
PSCustomObject. An object that represents a ThumbButton.

.EXAMPLE
$thumbButton = New-TaskbarItemThumbButton -Description 'Open Folder' -IconResourcePath imageres.dll -IconResourceIndex 3 -OnClicked {explorer.exe /root,D:\}

.LINK
https://docs.microsoft.com/en-us/dotnet/api/system.windows.shell.thumbbuttoninfo

#>
function New-TaskbarItemThumbButton
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Description,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$IconResourcePath,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Int]$IconResourceIndex = 0,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ScriptBlock]$OnClicked,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Switch]$KeepOpenWhenClicked,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Switch]$HideBackground
    )

    process
    {
        $info = New-Object System.Windows.Shell.ThumbButtonInfo

        $info.Description = $Description
        $info.DismissWhenClicked = (-not $KeepOpenWhenClicked)
        $info.IsBackgroundVisible = (-not $HideBackground)

        if ($IconResourcePath)
        {
            $info.ImageSource = GetImageSource $IconResourcePath $IconResourceIndex
        }

        if ($OnClicked)
        {
            $info.Command = CreateCommandFromScriptBlock $OnClicked
        }

        $thumbButton = [PSCustomObject]@{
            ThumbButtonInfo = $info
        }
        $thumbButton
    }
}
