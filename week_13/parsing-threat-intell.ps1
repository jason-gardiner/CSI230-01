# Array of websites containing threat intell
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

# Loop through the URLs for the rules list
foreach ($u in $drop_urls) {

    # Extract the filename
    $temp = $u.split("/")

    # The last element in the array plucked off is the filename
    $file_name = $temp[-1]

    if (Test-Path $file_name) {

        continue

    } else {

        # Download the rules list
        Invoke-WebRequest -Uri $u -OutFile "C:\Users\champuser\Desktop\CSI230-01\week_13\$file_name"

    } # close if statement

} # close foreach loop

# Array containing the filename
$input_paths = @('C:\Users\champuser\Desktop\CSI230-01\week_13\compromised-ips.txt','C:\Users\champuser\Desktop\CSI230-01\week_13\emerging-botcc.rules')

# Extract the IP addresses
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Append the IP addresses to the temporary IP list
select-string -Path $input_paths -Pattern $regex_drop | `
ForEach-Object { $_.Matches } | `
ForEach-Object { $_.Value } | Sort-Object | Get-Unique | `
Out-File -FilePath "C:\Users\champuser\Desktop\CSI230-01\week_13\ips-bad.tmp"

function Get-iptables {
    # Get the IP addresses discovered, loop through and replace the beghinning of the line with the IPTables syntax
    # After the IP address, add the remaining IPTables syntax and save the results to a file
    # iptables -A INPUT -s IP -j DROP
    (Get-Content -Path "C:\Users\champuser\Desktop\CSI230-01\week_13\ips-bad.tmp") | % `
    { $_ -replace "^","iptables -A INPUT -s " -replace "$"," -j DROP" } | `
    Out-File -FilePath "C:\Users\champuser\Desktop\CSI230-01\week_13\iptables.bash"
}

function Get-WindowsFirewall {
    (Get-Content -Path "C:\Users\champuser\Desktop\CSI230-01\week_13\ips-bad.tmp") | % `
    { $_ -replace "^","netsh advfirewall firewall add rule name=`"BLOCK IP ADDRESS - $_`" dir=in action=block remoteip=$_" } | `
    Out-File -FilePath "C:\Users\champuser\Desktop\CSI230-01\week_13\windows-firewall.bash"
}

function Ask-User {
    Write-Host "Choose which you would like to generate:"
    Write-Host "[i]ptables"
    Write-Host "[W]indows Firewall"
    $choice = Read-Host "Make your choice"
    switch ($choice) {
        'i' {
            Get-iptables
        }
        'W' {
            Get-WindowsFirewall
        }
        default {
            Write-Host "Invalid choice. Please try again."
            Ask-User
        }
    }
}

Ask-User