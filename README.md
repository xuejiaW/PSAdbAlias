# Adb Helper

PowerShell module that provides several helping functions based on Android Debug Bridge (ADB).

## Adb Aliases

Aliases for the most common ADB commands.

| Alias   | Command                        |
| ------- | ------------------------------ |
| `ad`    | `adb devices`                  |
| `al`    | `adb logcat`                   |
| `alc`   | `adb logcat -c`                |
| `als`   | `adb logcat \|Select-String`   |
| `ai`    | `adb install`                  |
| `aid`   | `adb install -d`               |
| `air`   | `adb install -r`               |
| `aidr`  | `adb install -d -r`            |
| `as`    | `adb shell`                    |
| `asas`  | `adb shell am start -n`        |
| `asp`   | `adb shell ps`                 |
| `asps`  | `adb shell ps \|Select-String` |
| `asast` | `adb shell am force-stop`      |

## App Helper

`AppHelper.ps1` contains helping functions that based on app info.

### Add-AppInfo

> [!tip]
>
> Alias: `aappi`

Normally, you first need to call `Add-AppInfo` to add app info which will be used in other functions

To add app info, you need to provide app name, package name and launch activity, like:

```powershell
Add-AppInfo -AppName "YourAppName" -PackageName "YourPackageName" -LaunchActivity "YourLaunchActivity"
```

Or，you can use alias `aappi` to add app info, like:

```powershell
aappi -AppName "YourAppName" -PackageName "YourPackageName" -LaunchActivity "YourLaunchActivity"
```
