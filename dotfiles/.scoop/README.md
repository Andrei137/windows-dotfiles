## Installation
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

## Setup
Make sure to edit `settings.json` first
```powershell
.\setup.ps1
```

## Sync
Useful for importing and exporting installed apps and buckets
```powershell
.\sync.ps1 [import | export (default)]
```

## Useful links
- [Docs](https://scoop.sh/)
