function wsl: {
    $wslUser = wsl whoami
    pushd \\wsl.localhost\Ubuntu\home\$wslUser
}

function xsrv {
    Start-Process "D:\Programming\Shell\wsl\VcXsrv\xsrv.lnk"
}

function zsh {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Command
    )

    wsl zsh -ic $Command
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