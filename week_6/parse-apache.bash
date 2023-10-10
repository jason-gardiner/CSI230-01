#!/bin/bash

# Storyline: Parses Apache Log for bad IP Addresses

# Define the path to the Apache log file
read -p "Please enter an apache log file." tFile

# Check if the Apache log file exists
if [[ ! -f ${tFile} ]]
then
  echo "File doesn't exists."
  exit 1
fi

# Parse the Apache log file to extract unique IP addresses
badIps=$(awk '{print $1}' "$tFile" | sort -u)

# Add IPTables rules for each IP address
for IP in $badIps
do
  # Add the IPTables rule to block incoming traffic from the IP
  echo "iptables -A INPUT -s $IP -j DROP" | tee -a badIPS.iptables
done

echo ""
echo "IPTables Ruleset Created"
echo""
