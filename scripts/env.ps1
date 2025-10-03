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

Write-Host "Environmental variables stage"
Write-Host "-----------------------------"

foreach ($param in $Params) {
    $value = Expand-PathVariables $param.value
    [Environment]::SetEnvironmentVariable($param.name, $value, "User")
    Write-Host "$($param.name) set to $value"
}
Write-Host ""
