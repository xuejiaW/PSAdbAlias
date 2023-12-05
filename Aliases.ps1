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