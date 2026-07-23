param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath,

    [Parameter(Mandatory = $true)]
    [array]$Params
)

$regPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

foreach ($exe in $Params) {
    $exePath = (Resolve-Path $exe).Path

    New-ItemProperty `
        -Path $regPath `
        -Name $exePath `
        -Value "~ RUNASADMIN" `
        -PropertyType String `
        -Force | Out-Null

    Write-Host "Configured to always run as administrator:"
    Write-Host "  $exePath"
}