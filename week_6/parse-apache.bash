#!/bin/bash

# Storyline: Parses Apache Logs for bad IP Addresses

# Check if the Apache log file exists
read -p "Please enter an apache log file." tFile
if [[ ! -f ${tFile} ]]
then
  echo "File doesn't exist."
  exit 1
fi

# Parse the Apache log file to extract unique IP addresses
badIps=$(awk '{print $1}' "$tFile" | sort -u)

# Add IPTables rules for each IP address
for IP in $badIps
do
  # Add the IPTables rule to block incoming traffic from the IP
  echo "iptables -A INPUT -s $IP -j DROP" | tee -a ${tFile}-badIPS.iptables
done

echo ""
echo "IPTables Ruleset Created"
echo""
