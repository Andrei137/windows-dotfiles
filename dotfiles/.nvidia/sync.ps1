param(
    [ValidateSet("export","import")]
    [string]$Action = "export"
)

$App = "$env:SCOOP\apps\nvpi\current\nvidiaProfileInspector.exe"
$File = "$PSScriptRoot\backup\all_profiles.nip"

if ($Action -eq "import") {
    try {
        & $App -silentImport "$File"

        if ($?) {
            Write-Host "NVIDIA profiles imported from $File"
        }
        else {
            Write-Warning "Import may have failed."
        }
    }
    catch {
        Write-Error $_
    }
}
else {
    $ExportDir = Split-Path $App
    $Before = @(Get-ChildItem $ExportDir -Filter "*.nip").FullName

    & $App -exportCustomized

    $Timeout = 15
    $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $Latest = $null

    do {
        Start-Sleep -Milliseconds 250

        $Latest = Get-ChildItem $ExportDir -Filter "*.nip" |
            Where-Object FullName -notin $Before |
            Select-Object -First 1
    }
    while (-not $Latest -and $Stopwatch.Elapsed.TotalSeconds -lt $Timeout)

    if (-not $Latest) {
        Write-Warning "Timed out waiting for NVIDIA Profile Inspector export."
        exit 1
    }

    Move-Item $Latest.FullName $File -Force
    Write-Host "NVIDIA profiles exported to $File"
}