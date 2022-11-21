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
![Countdown](https://user-images.githubusercontent.com/81177095/184890354-ad60b9cd-b918-41ad-b2a8-bd36b9e0c506.gif)

## Requirements

This module has been tested on:

- Windows 10 and 11 
- Windows PowerShell 5.1 and PowerShell 7.2

## Installation

*PoshTaskbarItem* is available on the PowerShell Gallery. You can install the module with the following command:

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

![Description](https://user-images.githubusercontent.com/81177095/184888853-8fa8ada8-c7a4-4845-ad49-817cd8fe6338.png)

```powershell
Set-TaskbarItemDescription $ti "Description is shown here"
```

Description is a text displayed on top of the taskbar preview window. It is shown by a mouse over.

### Thumb Button

![ThumbButton](https://user-images.githubusercontent.com/81177095/184888921-283873ae-a1a6-4505-a656-022be39c04c7.png)

```powershell
$thumbButton = New-TaskbarItemThumbButton -Description "Increment Badge Counter" -IconResourcePath "imageres.dll" -IconResourceIndex 101 -OnClicked {
    Write-Host "Clicked."
}
Add-TaskbarItemThumbButton $ti $thumbButton
```

ThumbButtons are the buttons displayed at the bottom of the preview window. You can add maximum 7 ThumbButtons to a TaskbarItem.

### Overlay Badge

![OverlayBadge](https://user-images.githubusercontent.com/81177095/184888975-5f6d0a5b-7120-4b42-8130-36c92ed317f3.png)

```powershell
Set-TaskbarItemOverlayBadge $ti -Text "2"
```

OverlayBadge is a text badge displayed on the taskbar icon. The badge size and the font size are changeable by parameters but 2 characters might be the maximum considering the space.

### Overlay Icon

![OverlayIcon](https://user-images.githubusercontent.com/81177095/184889028-d18a7476-9a9b-4d6f-9a47-2ff8f3bbc506.png)

```powershell
Set-TaskbarItemOverlayIcon $ti -IconResourcePath imageres.dll -IconResourceIndex 79
```

Instead of a text badge, you can also show an image as an overlay icon.

### Icon Flashing

![IconFlashing](https://user-images.githubusercontent.com/81177095/184889102-4b12a6d6-6a14-4189-aca5-541e51ce677d.png)

```powershell
Start-TaskbarItemFlashing $ti -Count 3
# ...
Stop-TaskbarItemFlashing $ti
```

You can flash the taskbar icon to get more attention of the user.

### Changing Application Icons

![AppIcon](https://user-images.githubusercontent.com/81177095/185406314-b1657a74-fc2f-44a2-8d45-04639bf2f6be.png)

If you run a script that uses *PoshTaskbarItem*, the PowerShell icon is shown on the taskbar by default. If you want to assign a new icon to your script, you have to create a shortcut that runs your script. You would also want to hide the PowerShell console so the command to create the shortcut will be like this:

```powershell
New-TaskbarItemShortcut -Path "D:\YourApp.lnk" -IconResourcePath "imageres.dll" -IconResourceIndex 144 -TargetPath "powershell.exe" -Arguments "-ExecutionPolicy Bypass -WindowStyle Hidden -File D:\YourScript.ps1" -WindowStyle Minimized
```

### IconResourcePath

Some of the functions take `IconResourcePath` and `IconResourceIndex` parameters to specify icon images. For `IconResourcePath`, you can use a relative path from the current directory, a relative path from `$env:PATH` or full path to a file that contains icon resources. The supported files are `.dll`, `.exe`, `.ico` and image files (`.png`, `.bmp`, `.tif`, `.gif` and `.jpg`). Depending on the function, image files are converted to `.ico` files which are placed next to the original image files. `IconResourceIndex` is a zero-based index value that specifies which one to use in case the resource file has multiple icon resources. 

On Windows 10 or 11, `imageres.dll` or `shell32.dll` has a lot of useful icons. You can see what kind of icons they have from the 'Change Icon' button in the shortcut property.

![IconResource](https://user-images.githubusercontent.com/81177095/185643184-e4987ab5-784f-4d3a-9a3f-fc8686c32ff6.png)

### Timer Function

`Show-TaskbarItem` function does not return until the taskbar item window is closed so if you need to do something periodically while the window is open, you have to use the Timer Function.

```powershell
Set-TaskbarItemTimerFunction $ti -IntervalInMillisecond 1000 {
    Write-Host "Tick"
}
```

The Timer Function is called on the UI thread with the interval time specified by a parameter. The function is not guaranteed to be executed exactly when the time interval occurs, but it is guaranteed to not be executed before the time interval occurs. Because it is called on the UI thread, it should not do anything that takes long time to complete.

## Help and more Examples

`Get-Command` can list all the available functions in the module:

```powershell
Get-Command -Module PoshTaskbarItem
```

To get the detailed help of a function, please try:

```powershell
Get-Help Add-TaskbarItemJumpTask -Full
```

For more code examples, please see the scripts under [Examples](./Examples) folder.
