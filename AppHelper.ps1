

$storagePath = Join-Path -Path $env:APPDATA -ChildPath "/PSModules/AdbHelper"
$storageFile = Join-Path -Path $storagePath -ChildPath "AppInfo.json"

function Add-AppInfo {
    param (
        [Parameter(Mandatory = $true)] [string]$AppName,
        [Parameter(Mandatory = $true)] [string]$PackageName,
        [Parameter(Mandatory = $true)] [string]$LaunchActivity
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

    $existedAppInfos | ConvertTo-Json | Set-Content $storageFile -Force
}

function Get-AppInfo {
    param (
        [string]$AppName,
        [Alias("l")] [switch]$List
    )

    if (-not (Test-Path -Path $storageFile)) {
        Write-Error "Can not find the storage file '$storageFile'"
        return
    }

    $existedAppInfos = Get-Content -Path $storageFile -ErrorAction Stop | ConvertFrom-Json

    if ($List) {
        $existedAppInfos | Format-Table -AutoSize
    }
    else {

        $selectedAppInfo = $existedAppInfos | Where-Object { $_.Name -eq $AppName }

        if ($selectedAppInfo) {
            return $selectedAppInfo
        }
        else {
            Write-Warning "Can not find the app info for '$AppName'"
            return $null
        }
    }
}

function Remove-AppInfo {
    param (
        [string]$AppName,
        [Alias("a")] [switch]$All

    )

    if ($All) {
        Write-Host "Delete app info storage file '$storageFile'"
        Remove-Item -Path $storageFile -Force
    }
    else {
        $existedAppInfos = Get-Content -Path $storageFile -ErrorAction Stop | ConvertFrom-Json
        $existedAppInfos = $existedAppInfos | Where-Object { $_.Name -ne $AppName }
        $existedAppInfos | ConvertTo-Json | Set-Content $storageFile -Force
    }

}

function Start-App {
    param (
        [Parameter(Mandatory = $true)][string]$AppName
    )

    $appInfo = Get-AppInfo -AppName $AppName
    asas -PackageName $appInfo.PackageName -LaunchActivity $appInfo.LaunchActivity
    
}

function Stop-App {
    param (
        [Parameter(Mandatory = $true)][string]$AppName
    )

    $appInfo = Get-AppInfo -AppName $AppName
    asast -PackageName $appInfo.PackageName
}

function Get-AppPID {
    param (
        [Parameter(Mandatory = $true)][string]$AppName
    )

    $appInfo = Get-AppInfo -AppName $AppName
    asps  $appInfo.PackageName
}

New-Alias -Name gappi -Value Get-AppInfo -Force
New-Alias -Name aappi -Value Add-AppInfo -Force
New-Alias -Name rappi -Value Remove-AppInfo -Force

New-Alias -Name sapp -Value Start-App -Force
New-Alias -Name stapp -Value Stop-App -Force

New-Alias -Name gapppid -Value Get-AppPID -Force
