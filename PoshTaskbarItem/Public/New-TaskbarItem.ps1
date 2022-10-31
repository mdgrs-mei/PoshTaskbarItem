<#
.SYNOPSIS
Creates a TaskbarItem.

.DESCRIPTION
Creates a new TaskbarItem that can be shown later by Show-TaskbarItem.

.PARAMETER Title
Window title of the TaskbarItem.

.PARAMETER IconResourcePath
File path to the icon resource that is used for the window icon. Note that this is not for the application icon on the taskbar.

.PARAMETER IconResourceIndex
Index of the icon resource that is used in case the icon resource has multiple icon files.

.PARAMETER OnClicked
ScriptBlock that is executed when the taskbar icon is clicked. The script block is called in the UI thread.

.INPUTS
None.

.OUTPUTS
PSCustomObject. An object that represents a TaskbarItem.

.EXAMPLE
New-TaskbarItem -Title "Window Title" -OnClicked {Write-Host "Hello."}

.EXAMPLE
New-TaskbarItem -IconResourcePath imageres.dll -IconResourceIndex 8

.EXAMPLE
New-TaskbarItem -IconResourcePath .\icon.png

#>
function New-TaskbarItem
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$Title,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [String]$IconResourcePath,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [Int]$IconResourceIndex = 0,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ScriptBlock]$OnClicked
    )

    process
    {
        $xamlPath = Join-Path $PSScriptRoot "..\Private\Window.xaml"
        $xaml = [Xml](Get-Content $xamlPath)
        $nodeReader = (New-Object System.Xml.XmlNodeReader $xaml)
        $window = [System.Windows.Markup.XamlReader]::Load($nodeReader)

        $window.Title = $Title

        if ($IconResourcePath)
        {
            $window.Icon = GetImageSource $IconResourcePath $IconResourceIndex
        }

        $jumpList = New-Object System.Windows.Shell.JumpList

        $taskbarItem = [PSCustomObject]@{
            Window = $window
            MainWindowHandle = 0
            SkipOnClicked = $false
            OnClicked = $OnClicked
            OnLoadedForOverlayBadge = $null
            Timer = $null
            JumpList = $jumpList
        }

        $window.add_Loaded({
            $taskbarItem.MainWindowHandle = (New-Object System.Windows.Interop.WindowInteropHelper($window)).Handle
            if ($taskbarItem.OnLoadedForOverlayBadge)
            {
                $taskbarItem.OnLoadedForOverlayBadge.Invoke()
            }
        }.GetNewClosure())

        $window.add_ContentRendered({
            # Immediately minimize the window after the thumbnail is rendered.
            $window.WindowState = [System.Windows.WindowState]::Minimized
        }.GetNewClosure())

        $window.add_StateChanged({
            if ($window.WindowState -eq [System.Windows.WindowState]::Minimized)
            {
                return
            }

            if ($taskbarItem.SkipOnClicked)
            {
                $taskbarItem.SkipOnClicked = $false
            }
            elseif ($taskbarItem.OnClicked)
            {
                $taskbarItem.OnClicked.Invoke()
            }

            $window.WindowState = [System.Windows.WindowState]::Minimized
        }.GetNewClosure())

        $taskbarItem
    }
}
