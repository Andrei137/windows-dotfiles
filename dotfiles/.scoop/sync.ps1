param(
    [ValidateSet("export","import")]
    [string]$Action = "export"
)

$File = "$PSScriptRoot\src\backup.json"

if ($Action -eq "import") {
    scoop import "$File"
    Write-Host "Scoop packages imported from $File"
}
else {
    scoop export > $File
    Write-Host "Scoop packages exported to $File"
}
