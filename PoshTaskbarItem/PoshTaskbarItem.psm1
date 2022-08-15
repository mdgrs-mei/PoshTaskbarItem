
Add-Type -AssemblyName PresentationFramework

$privateScripts = @(Get-ChildItem $PSScriptRoot\Private\*.ps1)
$publicScripts = @(Get-ChildItem $PSScriptRoot\Public\*.ps1)
foreach ($script in ($privateScripts + $publicScripts))
{
    . $script.FullName
}

Export-ModuleMember -Function $publicScripts.BaseName
