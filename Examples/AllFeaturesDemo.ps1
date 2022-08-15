Import-Module $PSScriptRoot\..\PoshTaskbarItem -Force

<#
# Create a shortcut on the Desktop to assign an icon to this demo app.
$params = @{
    Path = "$env:userprofile\Desktop\AllFeaturesDemo.lnk"
    IconResourcePath = "imageres.dll"
    IconResourceIndex = 144
    TargetPath = "powershell.exe"
    Arguments = ("-ExecutionPolicy Bypass -WindowStyle Hidden -File `"{0}`"" -f $MyInvocation.MyCommand.Path)
    WindowStyle = "Minimized"
}
New-TaskbarItemShortcut @params
#>

$description = "Description is shown here"
$clickCounter = 0
$badgeCounter = 0
$progress = 0.0
$showProgress = $false

# Create a new TaskbarItem
$params = @{
    Title = "All Features Demo"
    IconResourcePath = "imageres.dll"
    IconResourceIndex = 144
    OnClicked = {
        # Counts click count and show it in the description
        $script:clickCounter++
        $desc = $script:description + ("`n`n- You clicked me {0} times -" -f $script:clickCounter)
        Set-TaskbarItemDescription $ti $desc
    }
}
$ti = New-TaskbarItem @params

# Set initial description
Set-TaskbarItemDescription $ti $description

# Create ThumbButtons
$params = @{
    Description = "Increment Badge Counter"
    IconResourcePath = "imageres.dll"
    IconResourceIndex = 101
    KeepOpenWhenClicked = $true
    HideBackground = $true
    OnClicked = {
        $script:badgeCounter++
        Set-TaskbarItemOverlayBadge $ti -Text $script:badgeCounter
    }
}
$thumbButton1 = New-TaskbarItemThumbButton @params

$params = @{
    Description = "Show Overlay Icon"
    IconResourcePath = "imageres.dll"
    IconResourceIndex = 79
    KeepOpenWhenClicked = $false
    HideBackground = $false
    OnClicked = {
        Set-TaskbarItemOverlayIcon $ti -IconResourcePath imageres.dll -IconResourceIndex 79
    }
}
$thumbButton2 = New-TaskbarItemThumbButton @params

$params = @{
    Description = "Toggle Progress Indicator"
    IconResourcePath = "imageres.dll"
    IconResourceIndex = 147
    KeepOpenWhenClicked = $false
    HideBackground = $false
    OnClicked = {
        $script:showProgress = -not $script:showProgress
    }
}
$thumbButton3 = New-TaskbarItemThumbButton @params

$params = @{
    Description = "Flash Taskbar Icon"
    IconResourcePath = "imageres.dll"
    IconResourceIndex = 204
    KeepOpenWhenClicked = $false
    HideBackground = $false
    OnClicked = {
        Start-TaskbarItemFlashing $ti -Count 3
    }
}
$thumbButton4 = New-TaskbarItemThumbButton @params

Add-TaskbarItemThumbButton $ti $thumbButton1
Add-TaskbarItemThumbButton $ti $thumbButton2
Add-TaskbarItemThumbButton $ti $thumbButton3
Add-TaskbarItemThumbButton $ti $thumbButton4

# Set timer function to update the progress indicator
Set-TaskbarItemTimerFunction $ti -IntervalInMillisecond 1000 {
    if ($script:showProgress)
    {
        $script:progress += 0.1
        if ($script:progress -gt 1.0)
        {
            $script:progress = 0.0
        }
        Set-TaskbarItemProgressIndicator $ti -Progress $script:progress -State Paused
    }
    else
    {
        Set-TaskbarItemProgressIndicator $ti -State None
    }
}

# Create JumpTasks
$params = @{
    Title = "Jump Task 1"
    Description = "Description is shown here"
    IconResourcePath = "notepad.exe"
    ApplicationPath = "notepad.exe"
    Arguments = $MyInvocation.MyCommand.Path
    CustomCategory = "Custom Category"
}
$jumpTask1 = New-TaskbarItemJumpTask @params

$params = @{
    Title = "Jump Task 2"
    Description = "Description is shown here"
    IconResourcePath = "imageres.dll"
    IconResourceIndex = 4
    ApplicationPath = "explorer.exe"
    CustomCategory = "Custom Category"
}
$jumpTask2 = New-TaskbarItemJumpTask @params

$params = @{
    Title = "Jump Task 3"
    Description = "Description is shown here"
    IconResourcePath = "powershell.exe"
    ApplicationPath = "powershell.exe"
}
$jumpTask3 = New-TaskbarItemJumpTask @params

Add-TaskbarItemJumpTask $ti $jumpTask1
Add-TaskbarItemJumpTask $ti $jumpTask2
Add-TaskbarItemJumpTask $ti $jumpTask3

# Show
Show-TaskbarItem $ti

