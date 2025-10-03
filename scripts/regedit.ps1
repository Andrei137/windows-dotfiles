param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath,

    [Parameter(Mandatory=$true)]
    [psobject]$Params
)

$menuText = "Open with &$($Params.name)"
$exePath = $Params.exe -replace '\\', '\\'

Write-Host "Regedit stage"
Write-Host "-------------"

$contextTypes = @(
    @{
        Flag  = 'file'
        Key   = '*'
        Value = '%1'
        RegPath = 'HKEY_CURRENT_USER\Software\Classes\*\shell'
    },
    @{
        Flag  = 'folder'
        Key   = 'Directory'
        Value = '%1'
        RegPath = 'HKEY_CURRENT_USER\Software\Classes\Directory\shell'
    },
    @{
        Flag  = 'empty_space'
        Key   = 'Directory\Background'
        Value = '%V'
        RegPath = 'HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell'
    }
)

$addReg = @(
    "Windows Registry Editor Version 5.00",
    ""
)

$delReg = @(
    "Windows Registry Editor Version 5.00",
    ""
)

foreach ($ct in $contextTypes) {
    $flagName = $ct.Flag
    if ($Params.flags.$flagName) {
        $regBase = "$($ct.RegPath)\$menuText"

        $addReg += @(
            "[$regBase]",
            "@=`"$menuText`"",
            "`"Icon`"=`"$exePath`"",
            "",
            "[$regBase\command]",
            "@=`"\`"$exePath\`" $($Params.flags.$flagName)`"",
            ""
        )

        $delReg += @(
            "[-$regBase]",
            ""
        )
    }
}

if ($Params.flags.register_app) {
    $addReg += @(
        "[HKEY_CURRENT_USER\Software\Classes\Applications\$exeName\shell\open\command]",
        "@=`"$exePath $($Params.flags.register_app)`"",
        ""
    )
    $delReg += "[-HKEY_CURRENT_USER\Software\Classes\Applications\$exeName\shell\open]"
    $delReg += ""
}

$RegPath = Join-Path -Path $SourcePath -ChildPath "context"
if (-not (Test-Path -Path $RegPath)) {
    New-Item -Path $RegPath -ItemType Directory | Out-Null
}

$AddPath = Join-Path -Path $RegPath -ChildPath "add.reg"
$DelPath = Join-Path -Path $RegPath -ChildPath "delete.reg"

Set-Content -Path $AddPath -Value ($addReg -join "`r`n") -Encoding ASCII
Set-Content -Path $DelPath -Value ($delReg -join "`r`n") -Encoding ASCII

Write-Host "add.reg and delete.reg generated successfully inside $RegPath"
