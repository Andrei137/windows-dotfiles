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

Write-Host "Write stage"
Write-Host "-----------"

foreach ($param in $Params) {
    $Source = Join-Path $SourcePath $param.source
    $Destination = Expand-PathVariables $param.destination

    Write-Host "Copying $Source to $Destination"
    $parentDir = Split-Path -Path $Destination -Parent
    if (-not (Test-Path -Path $parentDir)) {
        New-Item -Path $parentDir -ItemType Directory -Force | Out-Null
    }

    if (Test-Path -Path $Destination -PathType Container) {
        Write-Host "Destination folder found! Overwriting contents..."
        Get-ChildItem -Path $Source | ForEach-Object {
            $destPath = Join-Path -Path $Destination -ChildPath $_.Name

            if ($_.PSIsContainer) {
                Copy-Item -Path $_.FullName -Destination $destPath -Recurse -Force
                Write-Host "Writing folder: $($_.FullName) -> $destPath"
            } else {
                Copy-Item -Path $_.FullName -Destination $destPath -Force
                Write-Host "Writing file: $($_.FullName) -> $destPath"
            }
        }
    }
    elseif (-not (Test-Path -Path $Destination)) {
        if ((Get-Item -Path $Source).PSIsContainer) {
            Copy-Item -Path $Source -Destination $Destination -Recurse -Force
            Write-Host "Writing folder: $Source -> $Destination"
        } else {
            Copy-Item -Path $Source -Destination $Destination -Force
            Write-Host "Writing file: $Source -> $Destination"
        }
    }
    else {
        Write-Warning "Target path already exists and is not a folder: $Destination"
    }
}
Write-Host ""
