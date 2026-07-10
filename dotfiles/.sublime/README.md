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

If `open_with` is kept in `settings.json`, the script will generate two `.reg` files, for adding and removing context menu

## Import
Symlinks don't work, so the config is copied. This is an util to import changes back to the repo
```powershell
.\import.ps1
```

## Useful links
- [Docs](https://www.sublimetext.com/)
