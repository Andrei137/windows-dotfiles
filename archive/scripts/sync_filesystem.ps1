param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath,

    [ValidateSet("export", "import")]
    [string]$Mode = "export",

    [array]$Params
)

function Expand-PathVariables {
    param([string]$Path)

    $expanded = [Environment]::ExpandEnvironmentVariables($Path)
    $ExecutionContext.SessionState.InvokeCommand.ExpandString($expanded)
}

# When importing, read the params from settings.json
if ($Mode -eq "import") {
    $data = Get-Content -Path (Join-Path $SourcePath "settings.json") -Raw | ConvertFrom-Json
    $Params = ($data | Where-Object { $_.action -eq "sync" }).params
}

Write-Host "$($Mode.Substring(0,1).ToUpper() + $Mode.Substring(1)) stage"
Write-Host ("-" * 12)

foreach ($param in $Params) {

    if ($Mode -eq "export") {
        $Source = Join-Path $SourcePath $param.source
        $Destination = Expand-PathVariables $param.destination

        Write-Host "Copying $Source -> $Destination"

        $parentDir = Split-Path -Path $Destination -Parent
        if (-not (Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }

        if (Test-Path $Destination -PathType Container) {
            Write-Host "Destination folder found! Overwriting contents..."

            Get-ChildItem $Source | ForEach-Object {
                $destPath = Join-Path $Destination $_.Name

                if ($_.PSIsContainer) {
                    Copy-Item $_.FullName $destPath -Recurse -Force
                    Write-Host "Writing folder: $($_.FullName) -> $destPath"
                }
                else {
                    Copy-Item $_.FullName $destPath -Force
                    Write-Host "Writing file: $($_.FullName) -> $destPath"
                }
            }
        }
        elseif (-not (Test-Path $Destination)) {
            if ((Get-Item $Source).PSIsContainer) {
                Copy-Item $Source $Destination -Recurse -Force
                Write-Host "Writing folder: $Source -> $Destination"
            }
            else {
                Copy-Item $Source $Destination -Force
                Write-Host "Writing file: $Source -> $Destination"
            }
        }
        else {
            Write-Warning "Target path already exists and is not a folder: $Destination"
        }
    }
    else {
        $Source = Expand-PathVariables $param.destination
        $Destination = Join-Path $SourcePath $param.source

        if (Test-Path $Destination) {
            Remove-Item $Destination -Recurse -Force
        }

        Copy-Item $Source $Destination -Recurse -Force
        Write-Host "Copied $Source -> $Destination"
    }
}

Write-Host ""