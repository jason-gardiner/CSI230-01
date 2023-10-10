#!/bin/bash

# Storyline: Parses Apache Log for bad IP Addresses

# Define the path to the Apache log file
pFile="access.log.txt"

# Check if the Apache log file exists
if [ ! -f "$pFile" ]
then
  echo "Apache log file not found. Exiting."
  exit 1
fi

# Parse the Apache log file to extract unique IP addresses
badIps=$(awk '{print $1}' "$pFile" | sort -u)

# Add IPTables rules for each IP address
for IP in $badIps
do
  # Add the IPTables rule to block incoming traffic from the IP
  echo "iptables -A INPUT -s $IP -j DROP" | tee -a badIPS.iptables
done
