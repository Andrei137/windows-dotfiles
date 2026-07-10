param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath,

    [ValidateSet("export", "import")]
    [string]$Mode = "export",

    [array]$Params
)

Write-Host "$($Mode.Substring(0,1).ToUpper() + $Mode.Substring(1)) stage"
Write-Host "-------------"

# When importing, load the registry keys from settings.json
if ($Mode -eq "import") {
    $data = Get-Content (Join-Path $SourcePath "settings.json") -Raw | ConvertFrom-Json
    $Params = ($data | Where-Object { $_.action -eq "regedit" }).params
}

$backupDir = Join-Path $SourcePath "src"

if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

foreach ($param in $Params) {
    $key = $param.key
    $name = $param.name

    $backupFile = Join-Path $backupDir "$name.reg"

    switch ($Mode) {
        "import" {
            Write-Host "Backing up '$key' -> '$backupFile'"

            & reg.exe export "$key" "$backupFile" /y | Out-Null

            if ($LASTEXITCODE -ne 0) {
                Write-Warning "Failed to back up '$key'."
            }
        }

        "export" {
            if (-not (Test-Path $backupFile)) {
                Write-Warning "Backup file not found: $backupFile"
                continue
            }

            Write-Host "Restoring '$backupFile'"

            & reg.exe import "$backupFile" | Out-Null

            if ($LASTEXITCODE -ne 0) {
                Write-Warning "Failed to restore '$backupFile'."
            }
        }
    }
}

Write-Host ""