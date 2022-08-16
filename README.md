<div align="center">

# PoshTaskbarItem

[![GitHub license](https://img.shields.io/github/license/mdgrs-mei/PoshTaskbarItem)](https://github.com/mdgrs-mei/PoshTaskbarItem/blob/main/LICENSE)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/p/PoshTaskbarItem)](https://www.powershellgallery.com/packages/PoshTaskbarItem)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/PoshTaskbarItem)](https://www.powershellgallery.com/packages/PoshTaskbarItem)

[![Pester Test](https://github.com/mdgrs-mei/PoshTaskbarItem/actions/workflows/pester-test.yml/badge.svg)](https://github.com/mdgrs-mei/PoshTaskbarItem/actions/workflows/pester-test.yml)

*PoshTaskbarItem* is a PowerShell module that helps you make a simple UI for your script on the Windows taskbar.

![Demo](https://user-images.githubusercontent.com/81177095/184648943-38273e0f-048f-4f4f-b335-f43d3e173619.gif)

</div>

Application icons on the Windows taskbar have some useful features such as ThumbButton, ProgressIndicator and overlay icons. *PoshTaskbarItem* enables you to utilize these taskbar item features from PowerShell without caring about WPF programming. It will help you create simple and easily accessible GUIs for your utility scripts.

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

This module has been tested on:

- Windows 10 and 11 
- Windows PowerShell 5.1 and PowerShell 7.2

## Installation

PoshTaskbarItem is available on the PowerShell Gallery. You can install the module with the following command for example:

```powershell
Install-Module -Name PoshTaskbarItem -Scope CurrentUser
```

## Typical Code Structure

The following will be the typical code structure of a script that uses this module:

1. Create a TaskbarItem.
    - `New-TaskbarItem`
1. Set static information of the TaskbarItem including the TimerFunction.
    - `Set-TaskbarItemTimerFunction`
    - `Add-TaskbarItemJumpTask`
    - `Add-TaskbarItemThumbButton`
1. In the script block you specified to the TimerFunction or OnClicked callbacks, update the information of the TaskbarItem.
    - `Set-TaskbarItemDescription`
    - `Set-TaskbarItemOverlayBadge`
    - `Set-TaskbarItemOverlayIcon`
    - `Set-TaskbarItemProgressIndicator`
1. Show the TaskbarItem. The function does not return until the window is closed so everything needs to be handled in the callbacks.
    - `Show-TaskbarItem`

## Features

In the following code examples, it is assumed that the TaskbarItem object is stored in the variable `$ti`.

```powershell
$ti = New-TaskbarItem
```

### Description

![Description](./Docs/Description.png)

```powershell
Set-TaskbarItemDescription $ti "Description is shown here"
```

Description is a text displayed on top of the taskbar preview window. It is shown by a mouse over.

### Thumb Button

![ThumbButton](./Docs/ThumbButton.png)

```powershell
$thumbButton = New-TaskbarItemThumbButton $ti -Description "Increment Badge Counter" -IconResourcePath "imageres.dll" -IconResourceIndex 101 -OnClicked {
    Write-Host "Clicked."
}
Add-TaskbarItemThumbButton $ti $thumbButton
```

ThumbButtons are the buttons displayed at the bottom of the preview window. You can add maximum 7 ThumbButtons to a TaskbarItem.

### Overlay Badge

![OverlayBadge](./Docs/OverlayBadge.png)

```powershell
Set-TaskbarItemOverlayBadge $ti -Text "2"
```

OverlayBadge is a text badge displayed on the taskbar icon. The size of the badge and the font are changeable by parameters but 2 characters might be the maximum considering the space.

### Overlay Icon

![OverlayIcon](./Docs/OverlayIcon.png)

```powershell
Set-TaskbarItemOverlayIcon $ti -IconResourcePath imageres.dll -IconResourceIndex 79
```

Instead of a text badge, you can also show an image as an overlay icon.

### Icon Flashing

![IconFlashing](./Docs/IconFlashing.png)

```powershell
Start-TaskbarItemFlashing $ti -Count 3
# ...
Stop-TaskbarItemFlashing $ti
```

You can flash the taskbar icon to get more attention of the user.

## Help and More Examples

`Get-Command` can list all the available functions in the module:

```powershell
Get-Command -Module PoshTaskbarItem
```

To get the detailed help of a function, please try:

```powershell
Get-Help Add-TaskbarItemJumpTask -Full
```

For more code examples, please see the scripts under [Examples](./Examples) folder.
