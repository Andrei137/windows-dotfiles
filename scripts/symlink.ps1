param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath,

    [Parameter(Mandatory=$true)]
    [array]$Params
)

function Expand-PathVariables {
    param([string]$Path)

    $expanded = [Environment]::ExpandEnvironmentVariables($Path)
    $ExecutionContext.SessionState.InvokeCommand.ExpandString($expanded)
}

Write-Host "Symlink stage"
Write-Host "-------------"

foreach ($param in $Params) {
    $Source = Join-Path $SourcePath $param.source
    $Destination = Expand-PathVariables $param.destination

    Write-Host "Linking $Source to $Destination"
    $parentDir = Split-Path -Path $Destination -Parent
    if (-not (Test-Path -Path $parentDir)) {
        New-Item -Path $parentDir -ItemType Directory -Force | Out-Null
    }

    if (Test-Path -Path $Destination -PathType Container) {
        Write-Host "Destination folder found! Trying to link contents..."
        Get-ChildItem -Path $Source | ForEach-Object {
            $linkPath = Join-Path -Path $Destination -ChildPath $_.Name

            if (-not (Test-Path -Path $linkPath)) {
                New-Item -Path $linkPath -ItemType SymbolicLink -Value $_.FullName | Out-Null
                Write-Host "Symlink created: $linkPath -> $($_.FullName)"
            } else {
                Write-Host "Skipped existing item: $linkPath"
            }
        }
    }
    elseif (-not (Test-Path -Path $Destination)) {
        New-Item -Path $Destination -ItemType SymbolicLink -Value $Source | Out-Null
        Write-Host "Symlink created: $Destination -> $Source"
    }
    else {
        Write-Warning "Target path already exists and is not a folder: $Destination"
    }
}
Write-Host ""