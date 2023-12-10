$customAliasesFile = Join-Path -Path $moduleStoragePath -ChildPath "CustomAliases.json"

function Add-CustomAlias {
    param (
        [Parameter(Mandatory = $true)] [string]$Alias,
        [Parameter(Mandatory = $true)] [string]$Command
    )
    
    [array]$cmdAliasList = if (Test-Path $customAliasesFile) {
        Get-Content $customAliasesFile -Raw | ConvertFrom-Json
    }
    else {
        @() 
    }

    $existCmdAlias = $cmdAliasList | Where-Object { $_.Alias -eq $Alias }
    if ($null -ne $existCmdAlias) {
        $existCmdAlias.Command = $Command
    }
    else {
        $newCmdAlias = [PSCustomObject]@{
            Alias   = $Alias
            Command = $Command
        }
        $cmdAliasList += $newCmdAlias
    }

    $cmdAliasList | ConvertTo-Json | Set-Content $customAliasesFile -Force
}

function Get-CustomAlias {
    param (
        [string]$Alias,
        [Alias("l")] [switch]$List
    )

    if (-not (Test-Path -Path $customAliasesFile)) {
        Write-Error "Can not find the custom alias saving file '$customAliasesFile'"
        return
    }

    $cmdAliasList = Get-Content -Path $customAliasesFile -ErrorAction Stop | ConvertFrom-Json

    if ($List) {
        $cmdAliasList | Format-Table -AutoSize
    }
    else {
        $existCmdAlias = $cmdAliasList | Where-Object { $_.Alias -eq $Alias }

        if ($existCmdAlias) {
            return $existCmdAlias
        }
        else {
            Write-Warning "Can not find the custom alias with alias '$Alias'"
            return $null
        }
    }
}

function Invoke-CustomAlias {
    param (
        [Parameter(Mandatory = $true)] [string]$Alias,
        [Parameter(Mandatory = $false)] [string[]]$Args
    )

    $cmdAlias = Get-CustomAlias -Alias $Alias

    if ($null -eq $cmdAlias) {
        return
    }

    $cmd = $cmdAlias.Command

    if ($null -ne $Args) {
        $cmd += " $Args"
    }

    Invoke-Expression $cmd
}

function Remove-CustomAlias {
    param (
        [string]$Alias,
        [Alias("a")] [switch]$All
    )

    if ($All) {
        Write-Host "Delete custom alias saving file '$customAliasesFile'"
        Remove-Item -Path $customAliasesFile -Force
    }
    else {
        [array]$cmdAliasList = Get-Content $customAliasesFile -Raw | ConvertFrom-Json
        $cmdAliasList = $cmdAliasList | Where-Object { $_.Alias -ne $Alias }
        $cmdAliasList | ConvertTo-Json | Set-Content $customAliasesFile -Force        
    }
}

New-Alias -Name gcma -Value Get-CustomAlias -Force
New-Alias -Name icma -Value Invoke-CustomAlias -Force
New-Alias -Name acma -Value Add-CustomAlias -Force
New-Alias -Name rcma -Value Remove-CustomAlias -Force