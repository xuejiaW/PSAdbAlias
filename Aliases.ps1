. $PSScriptRoot\AppHelper.ps1
. $PSScriptRoot\ApkHelper.ps1

# Adb Devices
function ad { & adb devices }

# Adb Log
function alc { & adb logcat -c }
function als { & adb logcat | Select-String @args }

# Adb Install
function ai { & adb install @args }
function aid { & adb install -d @args }
function air { & adb install -r @args }
function aidr { & adb install -d -r @args }

# Adb Shell
function as { & adb shell @args }
function asas {
    param (
        [string]$PackageName,
        [string]$LaunchActivity
    )
    & adb shell am start -n $PackageName/$LaunchActivity
}


# App Helper
New-Alias -Name gappi -Value Get-AppInfo -Force
New-Alias -Name aappi -Value Add-AppInfo -Force
New-Alias -Name gapki -Value Get-ApkInfo -Force
