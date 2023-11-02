function Get-ServiceLogs {
    Write-Host ""
    # Ask the user for an option
    $choice = Read-Host "Select an option:`n[A]ll`n[S]topped`n[R]unning`n[Q]uit`n"

    switch ($choice) {
        'a' {
            # Retrieve and write all service logs
            $services = Get-Service
            Write-Host "List of all services:"
            $services
        }
        's' {
            # Retrieve and write service logs that are stopped
            $services = Get-Service | Where { $_.Status -eq 'Stopped' }
            Write-Host "List of stopped services:"
            $services
        }
        'r' {
            # Retrieve and write service logs that are running
            $services = Get-Service | Where { $_.Status -eq 'Running' }
            Write-Host "List of running services:"
            $services
        }
        'q' {
            # Exit the function
            return
        }
        default {
            # Tell the user their choice is wrong
            Write-Host "Oops! That's not the droid you're looking for. Please select a valid option."
        }
    }

    # Call the function recursively
    Get-ServiceLogs
}

Get-ServiceLogs
