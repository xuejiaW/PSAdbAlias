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
        [Parameter(Mandatory = $true)][string]$PackageName,
        [Parameter(Mandatory = $true)][string]$LaunchActivity
    )
    Write-Host "Start app '$PackageName' with activity '$LaunchActivity'"
    & adb shell am start -n $PackageName/$LaunchActivity
}
function asp {
    & adb shell ps @args
}
function asps {
    & adb shell ps | Select-String @args
}
function asast {
    param (
        [string]$PackageName
    )

    Write-Host "Stop app '$PackageName"
    & adb shell am force-stop $PackageName
}