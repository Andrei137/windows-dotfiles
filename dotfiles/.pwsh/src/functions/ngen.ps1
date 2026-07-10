function Clear-NGENQueue {
    Write-Host Running NGEN compile for each applicable version. -ForegroundColor Green
    $NgenPath = Get-ChildItem -Path $Env:SystemRoot'\Microsoft.NET' -Recurse "ngen.exe" | % {$_.FullName}
    foreach ($element in $NgenPath) {
        Write-Host "Running .NET Optimization in $element";
        Start-Process -wait $element -ArgumentList "ExecuteQueuedItems"
    }
}

function Optimize-Assemblies {
    param (
        [string]$assemblyFilter = "Microsoft.PowerShell.",
        [string]$activity = "Native Image Installation"
    )

    try {
        $ngenPath = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\ngen.exe"

        # Check if ngen.exe exists
        if (-Not (Test-Path $ngenPath)) {
            Write-Host "Ngen.exe not found at $ngenPath. Make sure .NET Framework is installed."
            return
        }

        # Get a list of loaded assemblies
        $assemblies = [AppDomain]::CurrentDomain.GetAssemblies()

        # Filter assemblies based on the provided filter
        $filteredAssemblies = $assemblies | Where-Object { $_.FullName -ilike "$assemblyFilter*" }

        if ($filteredAssemblies.Count -eq 0) {
            Write-Host "No matching assemblies found for optimization."
            return
        }

        foreach ($assembly in $filteredAssemblies) {
            # Get the name of the assembly
            $name = [System.IO.Path]::GetFileName($assembly.Location)

            # Display progress
            Write-Progress -Activity $activity -Status "Optimizing $name"

            # Use Ngen to install the assembly
            Start-Process -FilePath $ngenPath -ArgumentList "install `"$($assembly.Location)`"" -Wait -WindowStyle Hidden
        }

        Write-Host "Optimization complete."
    } catch {
        Write-Host "An error occurred: $_"
    }
}
