. $PSScriptRoot\Aliases.ps1
. $PSScriptRoot\AppHelper.ps1
. $PSScriptRoot\ApkHelper.ps1

$FunctionToExport = @(
    'ad',
    'alc',
    'als',
    'ai',
    'aid',
    'air',
    'aidr',
    'asas',
    'Add-AppInfo',
    'Get-AppInfo',
    'Get-ApkInfo'
)

$AliasToExport = @(
    'gappi',
    'aappi',
    'gapki'
)

foreach ($Function in $FunctionToExport) {
    Remove-Alias $Function -Force -ErrorAction SilentlyContinue
}

foreach ($Alias in $AliasToExport) {
    Remove-Alias $Function -Force -ErrorAction SilentlyContinue
}

Export-ModuleMember -Function $FunctionToExport 
Export-ModuleMember -Alias $AliasToExport
