. $PSScriptRoot\AdbAliases.ps1
. $PSScriptRoot\AppHelper.ps1
. $PSScriptRoot\ApkHelper.ps1

$FunctionToExport = @(
    'ad',
    'al',
    'alc',
    'als',
    'ai',
    'aid',
    'air',
    'aidr',
    'asas',
    'asast',
    'asp',
    'asps',
    'Add-AppInfo',
    'Get-AppInfo',
    'Remove-AppInfo',
    'Start-App',
    'Stop-App',
    'Get-ApkInfo',
    "Get-AppPID"
)

$AliasToExport = @(
    'gappi',
    'aappi',
    'rappi',
    'gapki',
    'sapp',
    'stapp',
    'gapppid'
)

foreach ($Function in $FunctionToExport) {
    Remove-Alias $Function -Force -ErrorAction SilentlyContinue
}

foreach ($Alias in $AliasToExport) {
    Remove-Alias $Function -Force -ErrorAction SilentlyContinue
}

Export-ModuleMember -Function $FunctionToExport 
Export-ModuleMember -Alias $AliasToExport
