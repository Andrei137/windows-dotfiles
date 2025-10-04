# starship
function global:__lazy_starship {
    Remove-Item function:\prompt -Force -ErrorAction SilentlyContinue
    Invoke-Expression (& starship init powershell)
    & $function:prompt
}
Set-Item function:\prompt { __lazy_starship }

# OSC 7 for wezterm
$prompt = ""
function Invoke-Starship-PreCommand {
    $current_location = $executionContext.SessionState.Path.CurrentLocation
    if ($current_location.Provider.Name -eq "FileSystem") {
        $ansi_escape = [char]27
        $provider_path = $current_location.ProviderPath -replace "\\", "/"
        $prompt = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\"
    }
    $host.ui.Write($prompt)
}

# zoxide
Remove-Item Alias:cd -Force -ErrorAction SilentlyContinue
function global:cd {
    Remove-Item function:\cd -Force -ErrorAction SilentlyContinue
    Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
    cd @args
}

# fzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# scoop
Import-Module D:\Programming\Manager\scoop\modules\scoop-completion

# syntax highlighting
function global:Enable-SyntaxHighlighting {
    Remove-Item function:\Enable-SyntaxHighlighting -Force -ErrorAction SilentlyContinue
    Import-Module syntax-highlighting -ErrorAction SilentlyContinue
}
Enable-SyntaxHighlighting

# aliases
Set-Alias -Name s -Value subl

# custom keybindings
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function BackwardKillWord

# functions
$functionsPath = "D:\Programming\Config\dotfiles\.pwsh\src\functions"
if (Test-Path $functionsPath) {
    Get-ChildItem -Path $functionsPath -Filter *.ps1 | ForEach-Object {
        . $_.FullName
    }
}

