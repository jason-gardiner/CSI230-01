# Use the Get-WMI cmdlet
# Get-WMiobject -Class win32_service | select Name, PathName, ProcessId

# Get-WmiObject -list | where { $_.Name -ilike "Win32_[n-o]*" } | Sort-Object

# Get-WmiObject -Class Win32_Account | Get-Member

# Task: Grab the network adaptor information using the WMI class
# Get the IP address, default gateway, and the DNS servers.
# Bonus: get the DHCP server.

# Get IP address, default gateway, DNS servers, and DHCP server for network adapter
$networkAdapter = Get-WmiObject Win32_NetworkAdapterConfiguration | Where { $_.IPEnabled -eq $true }
$IPAddress = $networkAdapter.IPAddress
$DefaultGateway = $networkAdapter.DefaultIPGateway
$DNSServers = $networkAdapter.DNSServerSearchOrder
$DHCPServer = $networkAdapter.DHCPServer

# Display the information
Write-Host "IP Address: $IPAddress"
Write-Host "Default Gateway: $DefaultGateway"
Write-Host "DNS Servers: $($DNSServers -join ', ')"
Write-Host "DHCP Server: $DHCPServer"


# Task: Export your list of running processes and running services on your system into separate files.

# Export list of running processes to a text file
Get-Process | Select Name, Id | Out-File -FilePath "C:\users\champuser\Desktop\CSI230-01\week_9\RunningProcesses.txt"

# Export list of running services to a text file
Get-Service | Where { $_.Status -eq 'Running' } | Select DisplayName, ServiceName | `
Out-File -FilePath "C:\users\champuser\Desktop\CSI230-01\week_9\RunningServices.txt"


# Task: Write a program that can start and stop the Windows Calculator only using Powershell
# and using only the process name for the Windows Calculator (to start and stop it).

# Start calculator
Start win32calc

# Wait 5 seconds
Start-Sleep -Milliseconds 5000

# Stop calculator
Stop-Process -Name win32calc
