param(
    [string]$Name
)

$repoRoot = $PSScriptRoot
$dotfilesDir = Join-Path $repoRoot "dotfiles"

if (-not $Name) {
    $Name = Get-ChildItem $dotfilesDir -Directory |
        Select-Object -ExpandProperty Name |
        Sort-Object |
        fzf

    if (-not $Name) {
        return
    }
}

if (-not $Name.StartsWith(".")) {
    $Name = ".$Name"
}

$sourcePath = Join-Path $dotfilesDir $Name

if (-not (Test-Path $sourcePath -PathType Container)) {
    Write-Error "Dotfile module '$Name' not found."
    exit 1
}

& (Join-Path $repoRoot "scripts\setup.ps1") -SourcePath $sourcePath