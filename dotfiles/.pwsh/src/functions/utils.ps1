function pwshreset {
    . $PROFILE
}

function pwshconfig {
    subl $PROFILE
}

function pwshutils {
    subl "D:\Programming\Config\dotfiles\.pwsh\src\functions\utils.ps1"
}

function pwshwsl {
    subl "D:\Programming\Config\dotfiles\.pwsh\src\functions\wsl.ps1"
}

function starconfig {
    subl "D:\Programming\Shell\starship\config.toml"
}

function wezconfig {
    subl "D:\Programming\Shell\wezterm\config.lua"
}

function glazeconfig {
    subl "D:\Programming\Manager\glazewm\config.yaml"
}

Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
Remove-Item Alias:cat -Force -ErrorAction SilentlyContinue

function ls {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        $args
    )
    eza --all --git @args
}

function cat {
    param (
        [Parameter(Mandatory=$true)]
        [string]$path
    )

    bat --style plain $path
}

function fzfp {
    fzf --preview "bat --style plain --color always {}"
}

function pwdc {
    $pwd.Path | Set-Clipboard
    Write-Host "Copied to clipboard: $pwd"
}

function sf {
    $files = & fd @args 2>$null

    if ($files.Count -gt 1) {
        $files = ($files | fzf --multi)
    }
    if (-not $files) {
        return
    }

    subl $files
}

function jsq {
    param (
        [Parameter(Mandatory=$true)]
        [string]$file,
        [Parameter(Mandatory=$true)]
        [string]$field
    )

    if (Test-Path $file) {
        cat $file | dasel -r json $field
    } else {
        Write-Host "File not found: $file"
    }
}

function port {
    param (
        [int]$port,
        [switch]$d
    )

    if (-not $port) {
        netstat -ano
    }
    elseif (-not $d) {
        echo here
        netstat -ano | findstr ":$port"
    }
    elseif ($d) {
        $pids = netstat -ano | findstr ":$port" | Select-String "LISTENING" | ForEach-Object {
            ($_ -split "\s+")[-1]
        } | Sort-Object -Unique

        foreach ($processId in $pids) {
            Stop-Process -Id $processId -Force
            Write-Host "Killed Process ID $processId"
        }
    }
    else {
        Write-Host "Usage: port [port] [-d]"
    }
}

function cmp {
    param (
        [Parameter(Mandatory=$true)]
        [string]$source,
        [Parameter(Mandatory=$true)]
        [string]$destination
    )

    Write-Host "Comparing $source with $destination..."

    $sourceFiles = Get-ChildItem -Path $source -Recurse -File -ErrorAction SilentlyContinue |
                   ForEach-Object { $_.FullName.Replace($source, "") }

    $destFiles = Get-ChildItem -Path $destination -Recurse -File -ErrorAction SilentlyContinue |
                 ForEach-Object { $_.FullName.Replace($destination, "") }

    $differences = Compare-Object -ReferenceObject $sourceFiles -DifferenceObject $destFiles

    if ($differences) {
        Write-Host "Differences found!"
        $differences
    } else {
        Write-Host "Folders are identical!"
    }
}

function copyf {
    param (
        [Parameter(Mandatory=$true)]
        [string]$source,
        [Parameter(Mandatory=$true)]
        [string]$destination
    )

    robocopy $source $destination /E /MT:8 /R:0 /W:0 /XO /J /FFT /NJH /NJS /NS /NC /NFL /NDL
}

function movef {
    param (
        [Parameter(Mandatory=$true)]
        [string]$source,
        [Parameter(Mandatory=$true)]
        [string]$destination
    )

    robocopy $source $destination /MOVE /E /MT:8 /R:0 /W:0 /XO /J /FFT /NJH /NJS /NS /NC /NFL /NDL
}

function temp {
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Verbose -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\WINDOWS\Prefetch\*" -Recurse -Verbose -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:temp\*" -Recurse -Verbose -Force -ErrorAction SilentlyContinue
}

Remove-PSReadLineKeyHandler -Chord Ctrl+s
