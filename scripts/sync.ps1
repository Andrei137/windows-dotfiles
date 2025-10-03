param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath
)

function Expand-PathVariables {
    param([string]$Path)

    $expanded = [Environment]::ExpandEnvironmentVariables($Path)
    $ExecutionContext.SessionState.InvokeCommand.ExpandString($expanded)
}

$data = Get-Content -Path $(Join-Path $SourcePath "settings.json") -Raw | ConvertFrom-Json
$params = ($data | Where-Object { $_.action -eq 'write' }).params

foreach ($param in $Params) {
    $Source = Expand-PathVariables $param.destination
    $Destination = Join-Path $SourcePath $param.source

    if (Test-Path $Destination) {
        Remove-Item -Path $Destination -Recurse -Force
    }
    Copy-Item -Path $Source -Destination $Destination -Recurse -Force
    Write-Host "Copied $Source to $Destination"
}
