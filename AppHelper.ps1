$storagePath = Join-Path -Path $env:APPDATA -ChildPath "/PSModules/AdbHelper"
$storageFile = Join-Path -Path $storagePath -ChildPath "AppInfo.json"

function Add-AppInfo {
    param (
        [string]$AppName,
        [string]$PackageName,
        [string]$LaunchActivity
    )
    
    $storagePath = Split-Path -Parent $storageFile
    if (-not (Test-Path $storagePath)) {
        New-Item -ItemType Directory -Path $storagePath | Out-Null
    }

    [array]$existedAppInfos = if (Test-Path $storageFile) {
        Get-Content $storageFile -Raw | ConvertFrom-Json
    }
    else {
        @() 
    }

    $existingAppInfo = $existedAppInfos | Where-Object { $_.Name -eq $AppName }
    if ($null -ne $existingAppInfo) {
        $existingAppInfo.PackageName = $PackageName
        $existingAppInfo.LaunchActivity = $LaunchActivity
    }
    else {
        $appInfo = [PSCustomObject]@{
            Name           = $AppName
            PackageName    = $PackageName
            LaunchActivity = $LaunchActivity
        }
        $existedAppInfos += $appInfo
    }

    $existedAppInfos | ConvertTo-Json -Depth 5 | Set-Content $storageFile -Force
}

function Get-AppInfo {
    param (
        [string]$AppName
    )

    if (-not (Test-Path -Path $storageFile)) {
        Write-Error "Can not find the storage file '$storageFile'"
        return
    }

    $appInfos = Get-Content -Path $storageFile -ErrorAction Stop | ConvertFrom-Json

    $selectedAppInfo = $appInfos | Where-Object { $_.Name -eq $AppName }

    if ($selectedAppInfo) {
        return $selectedAppInfo
    }
    else {
        Write-Warning "Can not find the app info for '$AppName'"
        return $null
    }
}
