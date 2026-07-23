## Installation
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

## Sync
Useful for importing and exporting installed apps and buckets
```powershell
.\sync.ps1 [import | export (default)]
```

## Useful links
- [Docs](https://scoop.sh/)
