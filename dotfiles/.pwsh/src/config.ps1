$DOTFILES = "D:\Programming\Config\dotfiles"

$EnableProfileTiming = $true
if ($EnableProfileTiming) {
    $start = Get-Date
    $prev = $start
}

function Show-TimeDiff($label) {
    if ($EnableProfileTiming) {
        $now = Get-Date
        $elapsed = ($now - $script:prev).TotalMilliseconds
        Write-Host ("[INIT] {0,-30} {1,8:N0} ms" -f $label, $elapsed) -ForegroundColor DarkGray
        $script:prev = $now
    }
}

# --- starship ---
$starshipCache = "$DOTFILES\.starship\src\cache.ps1"
if (-not (Test-Path $starshipCache)) {
    starship init powershell | Out-File -Encoding utf8 $starshipCache
}
Show-TimeDiff "Starship cache prep"

function global:__init_starship {
    Remove-Item function:\prompt -Force -ErrorAction SilentlyContinue
    . $starshipCache
    & $function:prompt
    return ''
}
function global:prompt { __init_starship }
Show-TimeDiff "Starship init"

# --- wezterm OSC7 ---
function global:Invoke-Starship-PreCommand {
    $current_location = $executionContext.SessionState.Path.CurrentLocation
    if ($current_location.Provider.Name -eq "FileSystem") {
        $ansi_escape = [char]27
        $provider_path = $current_location.ProviderPath -replace "\\", "/"
        $prompt = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\"
        $host.ui.Write($prompt)
    }
}
Show-TimeDiff "WezTerm OSC7"

# --- zoxide ---
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
}
Show-TimeDiff "Zoxide init"

# --- fzf ---
if (Get-Command Set-PsFzfOption -ErrorAction SilentlyContinue) {
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}
Show-TimeDiff "fzf setup"

# --- syntax highlighting ---
Import-Module syntax-highlighting -ErrorAction SilentlyContinue
Show-TimeDiff "Syntax highlighting"

# --- aliases ---
Set-Alias -Name s -Value subl
Show-TimeDiff "Aliases"

# --- keybindings ---
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function BackwardKillWord
Show-TimeDiff "Custom keybindings"

# --- functions ---
$FUNCTIONS_PATH = "$DOTFILES\.pwsh\src\functions"
$pwshCache = "$FUNCTIONS_PATH\cache.ps1"

if ((-not (Test-Path $pwshCache)) -or
    ((Get-ChildItem -Path $FUNCTIONS_PATH -Filter *.ps1).LastWriteTime -gt (Get-Item $pwshCache).LastWriteTime)) {
    Get-ChildItem -Path $FUNCTIONS_PATH -Filter *.ps1 |
        Get-Content | Out-File -Encoding utf8 $pwshCache
}
Show-TimeDiff "Functions cache prep"

. $pwshCache
Show-TimeDiff "Functions loading"

if ($EnableProfileTiming) {
    $total = ((Get-Date) - $start).TotalMilliseconds
    Write-Host ("`n[TOTAL INIT TIME] {0:N0} ms" -f $total) -ForegroundColor Cyan
}
