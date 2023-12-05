# Adb Log
function alc { adb logcat -c  }
function als { adb logcat | Select-String @args }

# Adb Install
function aidr { adb install -d -r @args }