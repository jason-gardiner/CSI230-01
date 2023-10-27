# Storyline: Using the Get-process and Get-service

Get-Process | Get-Member
Get-Process | Select-Object ProcessName, Path, ID | `
Export-Csv -Path "C:\users\champuser\Desktop\CSI230-01\week_9\myProcesses.csv" -NoTypeInformation

Get-Service | Where { $_.Status -eq "Stopped" }
