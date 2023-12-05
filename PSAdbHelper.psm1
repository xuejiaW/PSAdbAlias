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
    'AddAppInfo',
    'GetAppInfo',
    'GetApkInfo'
)

foreach ($Function in $FunctionToExport) {
    Remove-Alias $Function -Force -ErrorAction SilentlyContinue
}

Export-ModuleMember -Function $FunctionToExport 
