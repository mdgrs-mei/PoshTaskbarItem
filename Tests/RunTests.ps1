#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.0.0"}

$config = New-PesterConfiguration
$config.Run.PassThru = $true
$config.Run.Path = $PSScriptRoot
$config.CodeCoverage.Enabled = $true
$config.CodeCoverage.Path = "$PSScriptRoot\..\PoshTaskbarItem\Public"

Invoke-Pester -Configuration $config
