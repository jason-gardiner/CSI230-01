# Storyline: Review the Security Event Log

# Directory to save files:
$myDir = "C:\Users\champuser\Desktop\CSI230-01\week_8\"

# List all the available Windows Event Logs
Get-EventLog -list

# Create a prompt to allow user to select the Log to view
$readLog = Read-host -Prompt "Please select a log to review from the list above"

# Create a prompt to allow user to search the Log selected
$searchLog = Read-host -Prompt "Please specify a keyword or phrase to search for"

# Print the results for the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$searchLog*" } | export-csv -NoTypeInformation `
-Path "$myDir\securityLogs.csv"
