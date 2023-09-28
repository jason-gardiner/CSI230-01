#!/bin/bash

# Storyline: Script to audit security best practices


# Ensure IP forwarding is disabled
sysctl net.ipv4.ip_forward
if [[ "$(sysctl net.ipv4.ip_forward | cut -d " " -f 3) != 0" ]]
then
	echo "IP Forwarding is currently enabled"
	echo "Run the following commands to disable it:"
  	echo "net.ipv4.ip_forward=0"
  	echo "sysctl -w net.ipv4.ip_forward=0"
  	echo "sysctl -w net.ipv4.route.flush=1"
else
 	 echo "IP Forwarding is already disabled"
fi
echo ""
sleep 1

# Ensure ICMP redirects are not accepted
sysctl net.ipv4.conf.all.accept_redirects
sysctl net.ipv4.conf.default.accept_redirects
if [[ "$((sysctl net.ipv4.conf.all.accept_redirects | cut -d " " -f 3 != 0) && (sysctl net.ipv4.conf.default.accept_redirects | cut -d " " -f 3 != 0) ]]
then
	echo "ICMP redirects are currently accepted"
	echo "Run the following commands to not accept them:"
  	echo "net.ipv4.conf.all.accept_redirects=0"
  	echo "net.ipv4.conf.default.accept_redirects=0"
  	echo "sysctl -w net.ipv4.conf.all.accept_redirects=0"
	echo " sysctl -w net.ipv4.conf.default.accept_redirects=0"
	echo "sysctl -w net.ipv4.route.flush=1"
  	sleep 1
else
 	 echo "ICMP redirects are already no accepted"
fi
echo ""
sleep 1

# Ensure permissions on /etc/crontab are configured


# Ensure permissions on /etc/cron.hourly are configured


# Ensure permissions on /etc/cron.daily are configured


# Ensure permissions on /etc/cron.weekly are configured


# Ensure permissions on /etc/cron.monthly are configured


# Ensure permissions on /etc/passwd are configured


# Ensure permissions on /etc/shadow are configured


# Ensure permissions on /etc/group are configured


# Ensure permissions on /etc/gshadow are configured


# Ensure permissions on /etc/passwd- are configured


# Ensure permissions on /etc/shadow- are configured


# Ensure permissions on /etc/group- are configured


# Ensure permissions on /etc/gshadow- are configured


# Ensure no legacy "+" entries exist in /etc/passwd


# Ensure no legacy "+" entries exist in /etc/shadow


# Ensure no legacy "+" entries exist in /etc/group


# Ensure root is the only UID 0 account

