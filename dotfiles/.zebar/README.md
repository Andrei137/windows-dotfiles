## Installation
I prefer using `scoop`, but any other method should work as well
```powershell
scoop bucket add extras
scoop install extras/zebar
```

## Setup
Make sure to edit `settings.json` first
```powershell
.\setup.ps1
```

## Sync
Symlinks don't work, so the config is copied. This is an util to sync changes back to the repo
```powershell
.\sync.ps1
```

## Useful links
- [Docs](https://github.com/glzr-io/zebar)
