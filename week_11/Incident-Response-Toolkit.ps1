function Continue-Menu {
    Read-Host "`nPress Enter to continue"
}

function Get-SavePath {
    param (
        [string]$description
    )

    do {
        Write-Host "Choose save location for {$description}:"
        Write-Host "1. Default path ($PSScriptRoot\Results\$description)"
        Write-Host "2. Custom path"

        $choice = Read-Host "Enter your choice"

        switch ($choice) {
            '1' {
                # This default choice is to make this process quick unless you want the files in some other spot of your computer
                $savePath = "$PSScriptRoot\Results"
                $validChoice = $true
            }
            '2' {
                $customPath = Read-Host "Enter the custom path"
                # Make sure the custom path works, if not then give the user the ability to try again
                if (Test-Path $customPath) {
                    $savePath = $customPath
                    $validChoice = $true
                } else {
                    Write-Host "The specified path does not exist. Please try again."
                    $validChoice = $false
                }
            }
            default {
                Write-Host "Invalid choice. Please try again."
                $validChoice = $false
            }
        }
    } while (-not $validChoice)

    Join-Path -Path $savePath -ChildPath "$description.csv"
}

function Show-Menu {
    Clear-Host
    Write-Host "1. Running Processes and their Paths"
    Write-Host "2. Registered Services and their Executable Paths"
    Write-Host "3. TCP Network Sockets"
    Write-Host "4. User Account Information"
    Write-Host "5. Network Adapter Configuration"
    Write-Host "6. Save Security Events"
    Write-Host "7. Save Installed Programs"
    Write-Host "8. Save Running Services"
    Write-Host "9. Save Network Connections"
    Write-Host "10. Create File Hashes and Save to Checksums.csv"
    Write-Host "11. Zip Results"
    Write-Host "Q. Quit"

    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        '1' {
            # Record Running Processes and their Paths into a .csv file
            $savePath = Get-SavePath -description "RunningProcesses"
            Get-Process | Select-Object ProcessName, Path | Export-Csv -Path $savePath -NoTypeInformation
            Write-Host "Running processes saved to $savePath."
            Continue-Menu
        }
        '2' {
            # Record Registered Services and their Executable Paths into a .csv file
            $savePath = Get-SavePath -description "RegisteredServices"
            Get-WmiObject Win32_Service | Select-Object DisplayName, PathName | Export-Csv -Path $savePath -NoTypeInformation
            Write-Host "Registered services saved to $savePath."
            Continue-Menu
        }
        '3' {
            # Record TCP Network Sockets into a .csv file
            $savePath = Get-SavePath -description "NetworkSockets"
            Get-NetTCPConnection | Export-Csv -Path $savePath -NoTypeInformation
            Write-Host "Network sockets saved to $savePath."
            Continue-Menu
        }
        '4' {
            # Record User Account Information into a .csv file
            $savePath = Get-SavePath -description "UserAccounts"
            Get-WmiObject Win32_UserAccount | Select-Object Name, Domain, LocalAccount | Export-Csv -Path $savePath -NoTypeInformation
            Write-Host "User accounts saved to $savePath."
            Continue-Menu
        }
        '5' {
            # Record Network Adapter Configuration into a .csv file
            $savePath = Get-SavePath -description "NetworkAdapterConfiguration"
            Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object Description, IPAddress, MACAddress |
                Export-Csv -Path $savePath -NoTypeInformation
            Write-Host "Network adapter configuration saved to $savePath."
            Continue-Menu
        }
        '6' {
            # Record Security Events into a .csv file
            # I chose Security Events because it seemed like important data
            $savePath = Get-SavePath -description "SecurityEvents"
            Get-WinEvent -LogName Security -MaxEvents 1000 | Select-Object TimeCreated, Id, Message |
                Export-Csv -Path $savePath -NoTypeInformation
            Write-Host "Security events saved to $savePath."
            Continue-Menu
        }
        '7' {
            # Record Installed Programs into a .csv file
            # I chose Installed Programs because it was interesting
            $savePath = Get-SavePath -description "InstalledPrograms"
            Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
                Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Export-Csv -Path $savePath -NoTypeInformation
            Write-Host "Installed programs saved to $savePath."
            Continue-Menu
        }
        '8' {
            # Record Running Processes and their Paths into a .csv file
            $savePath = Get-SavePath -description "RunningServices"
            Get-Service | Select-Object DisplayName, ServiceName, StartType, Status | Export-Csv -Path $savePath -NoTypeInformation
            Write-Host "Running services saved to $savePath."
            Continue-Menu
        }
        '9' {
            # Record Running Services into a .csv file
            # I chose Running Services because I wasn't quite sure what it meant, and I wanted to figure it out
            $savePath = Get-SavePath -description "NetworkConnections"
            Get-NetTCPConnection | Export-Csv -Path $savePath -NoTypeInformation
            Write-Host "Network connections saved to $savePath."
            Continue-Menu
        }
        '10' {
            # Record File Hashes into a .csv file
             $resultsDirectory = "$PSScriptRoot\Results"
             
             $csvFiles = Get-ChildItem -Path $resultsDirectory -Filter *.csv
             
             if ($csvFiles.Count -eq 0) {
                Write-Host "No CSV files found in the specified directory. Exiting..."
                return
             }
             
             $checksumsFilePath = Join-Path -Path $resultsDirectory -ChildPath "Checksums.csv"
             # Exclude the checksums file itself, if it already exists
             if (Test-Path $checksumsFilePath) {
                $csvFiles = $csvFiles | Where-Object { $_.FullName -ne $checksumsFilePath }
             }
             
             $hashes = @()
             
             foreach ($file in $csvFiles) {
                $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256
                $hashObject = [PSCustomObject]@{
                    Checksum = $hash.Hash
                    FileName = $file.Name
                }
                $hashes += $hashObject
             }
            
            $savePath = Get-SavePath -description "Checksums"
            $hashes | Export-Csv -Path $savePath -NoTypeInformation
            
            Write-Host "File hashes created and saved to $savePath."

            Continue-Menu
        }
        '11' {
            # Zips up the Results folder
            $resultsDirectory = "$PSScriptRoot\Results"
            
            $zipFilePath = "$PSScriptRoot\Results.zip"
            
             # Check if the zip file already exists
             if (Test-Path $zipFilePath) {
                # Update the existing zip file
                Compress-Archive -Path $resultsDirectory -Update -DestinationPath $zipFilePath
                Write-Host "Results directory updated and saved to $($zipFilePath)."
             } else {
                # Create a new zip file
                Compress-Archive -Path $resultsDirectory -DestinationPath $zipFilePath
                Write-Host "Results directory zipped and saved to $($zipFilePath)."
             }
             
             # Calculate checksum of the zipped file and save it to a CSV file
             $zipFileChecksum = Get-FileHash -Path $zipFilePath -Algorithm SHA256
             $checksumFilePath = "$PSScriptRoot\ChecksumForZip.csv"
             $checksumObject = [PSCustomObject]@{
                Checksum = $zipFileChecksum.Hash
                FileName = $zipFilePath
             }
             $checksumObject | Export-Csv -Path $checksumFilePath -NoTypeInformation
             
             Write-Host "Checksum of the zipped file saved to $($checksumFilePath)."
             
             Continue-Menu
        }
        'Q' {
            return
        }
        default {
            Write-Host "Invalid choice. Please try again."
            Continue-Menu
        }
    }
    Show-Menu
}

Show-Menu
