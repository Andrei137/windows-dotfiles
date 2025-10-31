function wsl: {
    $wslUser = wsl whoami
    pushd \\wsl.localhost\Ubuntu\home\$wslUser
}

function xsrv {
    vcxsrv :0 -multiwindow -ac -wgl
}

function zsh {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Command
    )

    wsl zsh -ic $Command
}

function nvim {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )

    wsl zsh -ic "nvim '$FilePath'"
}

function which {
    param (
        [Parameter(Mandatory=$true)]
        [string]$command
    )
    (Get-Command -Name $command -ErrorAction SilentlyContinue).Path
}

function quit {
    exit
}

function touch {
    foreach ($file in $args) {
        if (-not (Test-Path $file)) {
            New-Item -Path $file -ItemType File -Force
        }
    }
}

function rem {
    foreach ($file in $args) {
        if (Test-Path $file) {
            Remove-Item -Path $file -Force
        }
    }
}