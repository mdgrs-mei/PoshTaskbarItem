<div align="center">

# PoshTaskbarItem

[![Pester Test](https://github.com/mdgrs-mei/PoshTaskbarItem/actions/workflows/pester-test.yml/badge.svg)](https://github.com/mdgrs-mei/PoshTaskbarItem/actions/workflows/pester-test.yml)

PoshTaskbarItem is a PowerShell module that helps you make a simple UI for your script on the Windows taskbar.

![Demo](https://user-images.githubusercontent.com/81177095/184648943-38273e0f-048f-4f4f-b335-f43d3e173619.gif)

</div>

Application icons on the Windows taskbar have some useful features such as ThumbButton, ProgressIndicator and overlay icons. However, you have to create a window to get the icon and WPF programming is required to access those taskbar item features.

PoshTaskbarItem enables you to utilize the taskbar item features from PowerShell. It will help you create simple and easily accessible GUIs for your utility scripts.

## Quick Example

The following code creates a taskbar icon showing a decreasing counter as an overlay badge. Clicking the icon resets the counter. This example is small but it should show a general idea of the module.

```powershell
$counter = 10
$ti = New-TaskbarItem -Title "Countdown" -OnClicked {
    $script:counter = 10
    UpdateUi
}

Set-TaskbarItemTimerFunction $ti -IntervalInMillisecond 1000 {
    $script:counter = [Math]::Max($script:counter-1, 0)
    UpdateUi
}

function UpdateUi
{
    Set-TaskbarItemOverlayBadge $ti -Text $script:counter -BackgroundColor "LightSeaGreen"
    Set-TaskbarItemProgressIndicator $ti -Progress ($script:counter/10) -State Paused
}

Show-TaskbarItem $ti
```

![Countdown](https://user-images.githubusercontent.com/81177095/184651151-16f5826c-b298-4474-9675-d58b05d9935a.gif)

## Requirements

- Tested on Windows 10/11 and PowerShell 5.1

## Installation

PoshTaskbarItem is available on the PowerShell Gallery. You can install the module with the following command for example:

```powershell
Install-Module -Name PoshTaskbarItem -Scope CurrentUser
```
