function GetApkInfo {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ApkPath
    )
   
    if (-not (Test-Path $ApkPath)) {
        Write-Error "Apk path '$ApkPath' does not exist"
        return
    }

    $output = & aapt dump badging $ApkPath
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to dump badging for '$ApkPath'"
        return
    }

    $result = [PSCustomObject]@{
        PackageName    = $null
        LaunchActivity = $null
    }    


    foreach ($line in $output) {
        if ($line.StartsWith("package:")) {
            $match = [Regex]::Match($line, "name='(?<packageName>[^']*)'")
            if ($match.Success) {
                $result.PackageName = $match.Groups["packageName"].Value
            }
        }

        if ($line -match "launchable-activity: name='(?<launchActivity>[^']*)'") {
            $result.LaunchActivity = $matches['launchActivity']
        }
    }

    return $result
}
