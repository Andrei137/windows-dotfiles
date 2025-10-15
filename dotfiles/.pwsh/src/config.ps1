$DOTFILES = "D:\Programming\Config\dotfiles"

# starship
$starshipCache = "$DOTFILES\.starship\src\cache.ps1"
if (-not (Test-Path $starshipCache)) {
    starship init powershell | Out-File -Encoding utf8 $starshipCache
}

function global:__init_starship {
    Remove-Item function:\prompt -Force -ErrorAction SilentlyContinue
    . $starshipCache
    & $function:prompt
    return ''
}
function global:prompt { __init_starship }

# OSC 7 for wezterm
function global:Invoke-Starship-PreCommand {
    $current_location = $executionContext.SessionState.Path.CurrentLocation
    if ($current_location.Provider.Name -eq "FileSystem") {
        $ansi_escape = [char]27
        $provider_path = $current_location.ProviderPath -replace "\\", "/"
        $prompt = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\"
        $host.ui.Write($prompt)
    }
}

# zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
}

# fzf
if (Get-Command Set-PsFzfOption -ErrorAction SilentlyContinue) {
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# syntax highlighting
Import-Module syntax-highlighting -ErrorAction SilentlyContinue

# aliases
Set-Alias -Name s -Value subl

# custom keybindings
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function BackwardKillWord

# functions
$FUNCTIONS_PATH = "$DOTFILES\.pwsh\src\functions"
$pwshCache = "$FUNCTIONS_PATH\cache.ps1"
if ((-not (Test-Path $pwshCache)) -or
    ((Get-ChildItem -Path $FUNCTIONS_PATH -Filter *.ps1).LastWriteTime -gt (Get-Item $pwshCache).LastWriteTime)) {
    Get-ChildItem -Path $FUNCTIONS_PATH -Filter *.ps1 |
        Get-Content | Out-File -Encoding utf8 $pwshCache
}
. $pwshCache
