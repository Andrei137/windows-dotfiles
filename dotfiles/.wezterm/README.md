## Installation
I prefer using `scoop`, but any other method should work as well
```powershell
scoop bucket add extras
scoop install wezterm
```

## Setup
Make sure to edit `settings.json` first
```powershell
.\setup.ps1
```

If `regedit` is kept in `settings.json`, the script will generate two `.reg` files, for adding and removing context menu

## Useful links
- [Docs](https://wezterm.org/index.html)
