Import-Module $PSScriptRoot\..\PoshTaskbarItem -Force

$params = @{
    Title = "MemoryMonitor"
    IconResourcePath = "imageres.dll"
    IconResourceIndex = 144
    OnClicked = {
        taskmgr
    }
}

$ti = New-TaskbarItem @params

Set-TaskbarItemTimerFunction $ti -IntervalInMillisecond 3000 {
    $os = Get-WmiObject Win32_OperatingSystem
    [Int]$usage = 100 * ($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / $os.TotalVisibleMemorySize

    $processes = Get-Process | Sort-Object -Property WorkingSet -Descending
    $top5 = $processes[0..4]    
    $processNames = $top5.Name -join "`n"

    $color = "LightSeaGreen"
    if ($usage -ge 50)
    {
        $color = "DeepPink"
    }

    Set-TaskbarItemOverlayBadge $ti -Text $usage -FontSize 10 -BackgroundColor $color
    Set-TaskbarItemDescription $ti $processNames
}

Show-TaskbarItem $ti
