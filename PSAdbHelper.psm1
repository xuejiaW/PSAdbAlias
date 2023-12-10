$Script:moduleStoragePath = Join-Path -Path $env:APPDATA -ChildPath "/PSModules/AdbHelper"

if (-not (Test-Path $moduleStoragePath)) {
    New-Item -ItemType Directory -Path $moduleStoragePath | Out-Null
}


. $PSScriptRoot\AdbAliases.ps1
. $PSScriptRoot\AppHelper.ps1
. $PSScriptRoot\ApkHelper.ps1
. $PSScriptRoot\CustomAliases.ps1

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
    # AppHelper
    'Add-AppInfo',
    'Get-AppInfo',
    'Remove-AppInfo',
    'Start-App',
    'Stop-App',
    "Get-AppPID",
    # ApkHelper
    'Get-ApkInfo',
    # CustomAliases
    'Add-CustomAlias',
    'Get-CustomAlias',
    'Invoke-CustomAlias',
    'Remove-CustomAlias'
)

$AliasToExport = @(
    'gappi', # Get-AppInfo
    'aappi', # Add-AppInfo
    'rappi', # Remove-AppInfo
    'gapki', # Get-ApkInfo
    'sapp', # Start-App
    'stapp', # Stop-App
    'gapppid', # Get-AppPID
    'gcma', # Get-CustomAlias
    'icma', # Invoke-CustomAlias
    'acma', # Add-CustomAlias
    'rcma' # Remove-CustomAlias
)

foreach ($Function in $FunctionToExport) {
    Remove-Alias $Function -Force -ErrorAction SilentlyContinue
}

foreach ($Alias in $AliasToExport) {
    Remove-Alias $Function -Force -ErrorAction SilentlyContinue
}

Export-ModuleMember -Function $FunctionToExport 
Export-ModuleMember -Alias $AliasToExport
