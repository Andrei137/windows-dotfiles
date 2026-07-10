param(
    [Parameter(Mandatory=$true)]
    [String]$SourcePath
)

$data = Get-Content -Path $(Join-Path $SourcePath "settings.json") -Raw | ConvertFrom-Json
foreach ($step in $data) {
    & (Join-Path $PSScriptRoot "$($step.action).ps1") `
        -SourcePath $SourcePath `
        -Params $step.params
}
