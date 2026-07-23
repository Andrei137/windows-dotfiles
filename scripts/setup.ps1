param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath
)

function Resolve-Value {
    param(
        [Parameter(Mandatory = $true)]
        $Value,

        [Parameter(Mandatory = $true)]
        [hashtable]$Variables
    )

    if ($Value -is [string]) {
        $Value = [System.Environment]::ExpandEnvironmentVariables($Value)

        foreach ($key in $Variables.Keys) {
            $Value = $Value.Replace('$' + '{' + $key + '}', $Variables[$key])
        }

        return $Value
    }

    if ($Value -is [System.Collections.IList]) {
        for ($i = 0; $i -lt $Value.Count; $i++) {
            $Value[$i] = Resolve-Value -Value $Value[$i] -Variables $Variables
        }

        return $Value
    }

    if ($Value -is [psobject]) {
        foreach ($property in $Value.PSObject.Properties) {
            $property.Value = Resolve-Value -Value $property.Value -Variables $Variables
        }

        return $Value
    }

    return $Value
}

$variables = @{
    MODULE_DIR = $SourcePath
}

$data = Get-Content (Join-Path $SourcePath "settings.json") -Raw | ConvertFrom-Json

foreach ($step in $data) {
    $params = Resolve-Value -Value $step.params -Variables $variables

    & (Join-Path $PSScriptRoot "$($step.action).ps1") `
        -SourcePath $SourcePath `
        -Params $params
}