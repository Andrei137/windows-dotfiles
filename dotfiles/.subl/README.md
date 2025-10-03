## Installation
I prefer using `scoop`, but any other method should work as well
```powershell
scoop install sublime-text
```

## Setup
Make sure to edit `settings.json` first
```powershell
.\setup.ps1
```

If `regedit` is kept in `settings.json`, the script will generate two `.reg` files, for adding and removing context menu

## Sync
Symlinks don't work, so the config is copied. This is an util to sync changes back to the repo
```powershell
.\sync.ps1
```

## Useful links
- [Docs](https://www.sublimetext.com/)
