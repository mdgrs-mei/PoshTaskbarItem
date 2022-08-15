Import-Module $PSScriptRoot\..\PoshTaskbarItem -Force

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

