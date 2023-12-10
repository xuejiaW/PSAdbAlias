$appInfoFile = Join-Path -Path $moduleStoragePath -ChildPath "AppInfo.json"

function Add-AppInfo {
    param (
        [Parameter(Mandatory = $true)] [string]$AppName,
        [Parameter(Mandatory = $true)] [string]$PackageName,
        [Parameter(Mandatory = $true)] [string]$LaunchActivity
    )
    
    [array]$appInfoList = if (Test-Path $appInfoFile) {
        Get-Content $appInfoFile -Raw | ConvertFrom-Json
    }
    else {
        @() 
    }

    $existAppInfo = $appInfoList | Where-Object { $_.Name -eq $AppName }
    if ($null -ne $existAppInfo) {
        $existAppInfo.PackageName = $PackageName
        $existAppInfo.LaunchActivity = $LaunchActivity
    }
    else {
        $newAppInfo = [PSCustomObject]@{
            Name           = $AppName
            PackageName    = $PackageName
            LaunchActivity = $LaunchActivity
        }
        $appInfoList += $newAppInfo
    }

    $appInfoList | ConvertTo-Json | Set-Content $appInfoFile -Force
}

function Get-AppInfo {
    param (
        [string]$AppName,
        [Alias("l")] [switch]$List
    )

    if (-not (Test-Path -Path $appInfoFile)) {
        Write-Error "Can not find the app info saving file '$appInfoFile'"
        return
    }

    $appInfoList = Get-Content -Path $appInfoFile -ErrorAction Stop | ConvertFrom-Json

    if ($List) {
        $appInfoList | Format-Table -AutoSize
    }
    else {

        $existAppInfo = $appInfoList | Where-Object { $_.Name -eq $AppName }

        if ($existAppInfo) {
            return $existAppInfo
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
        Write-Host "Delete app info saving file '$appInfoFile'"
        Remove-Item -Path $appInfoFile -Force
    }
    else {
        [array]$appInfoList = Get-Content -Path $appInfoFile -ErrorAction Stop | ConvertFrom-Json
        $appInfoList = $appInfoList | Where-Object { $_.Name -ne $AppName }
        $appInfoList | ConvertTo-Json | Set-Content $appInfoFile -Force
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
