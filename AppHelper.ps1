$storagePath = Join-Path -Path $env:APPDATA -ChildPath "PowerShellAppInfo"
$storageFile = Join-Path -Path $storagePath -ChildPath "AppInfo.json"

function AddAppInfo {
    param (
        [string]$AppName,
        [string]$PackageName,
        [string]$LaunchActivity
    )
    
    $existedAppInfos = if (Test-Path $storageFile) {
        Get-Content $storageFile | ConvertFrom-Json 
    }
    else {
        @() 
    }

    if (-not (Test-Path $storagePath)) {
        New-Item -ItemType Directory -Path $storagePath | Out-Null
    }

    $appInfo = [PSCustomObject]@{
        Name           = $AppName
        PackageName    = $PackageName
        LaunchActivity = $LaunchActivity
    }    
   
    $existedAppInfos += $appInfo
    $existedAppInfos | ConvertTo-Json | Out-File $storageFile -Force
}

function GetAppInfo {
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
