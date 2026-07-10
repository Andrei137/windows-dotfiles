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

function Import-Filesystem {
    param($Param)

    $Source = Expand-PathVariables $Param.destination
    $Destination = Join-Path $SourcePath $Param.source

    if (Test-Path $Destination) {
        Remove-Item $Destination -Recurse -Force
    }

    Copy-Item $Source $Destination -Recurse -Force
    Write-Host "Copied $Source -> $Destination"
}

function Export-Filesystem {
    param($Param)

    $Source = Join-Path $SourcePath $Param.source
    $Destination = Expand-PathVariables $Param.destination

    Write-Host "Copying $Source -> $Destination"

    $parentDir = Split-Path $Destination -Parent
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

function Import-Regedit {
    param($Param)

    $BackupFile = Join-Path $SourcePath $Param.source

    Write-Host "Backing up $($Param.destination) -> $BackupFile"

    & reg.exe export "$($Param.destination)" "$BackupFile" /y | Out-Null

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to export '$($Param.destination)'."
    }
}

function Export-Regedit {
    param($Param)

    $BackupFile = Join-Path $SourcePath $Param.source

    if (-not (Test-Path $BackupFile)) {
        Write-Warning "Backup not found: $BackupFile"
        return
    }

    Write-Host "Restoring $BackupFile"

    & reg.exe import "$BackupFile" | Out-Null

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to import '$BackupFile'."
    }
}

# Load params from settings.json when importing
if ($Mode -eq "import") {
    $data = Get-Content (Join-Path $SourcePath "settings.json") -Raw | ConvertFrom-Json
    $Params = ($data | Where-Object { $_.action -eq "sync" }).params
}

Write-Host "$($Mode.Substring(0,1).ToUpper() + $Mode.Substring(1)) stage"
Write-Host "-------------"

switch ($Mode) {
    "import" {
        foreach ($Param in $Params) {
            switch ($Param.type) {
                "filesystem" { Import-Filesystem $Param }
                "regedit"    { Import-Regedit $Param }
                default      { Write-Warning "Unknown sync type '$($Param.type)'" }
            }
        }
    }

    "export" {
        foreach ($Param in $Params) {
            switch ($Param.type) {
                "filesystem" { Export-Filesystem $Param }
                "regedit"    { Export-Regedit $Param }
                default      { Write-Warning "Unknown sync type '$($Param.type)'" }
            }
        }
    }
}

Write-Host ""