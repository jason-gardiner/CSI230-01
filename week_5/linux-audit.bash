#!/bin/bash

# Storyline: Script to audit security best practices

# Function to check permissions and print remediation
check_permissions() {
    file="$1"
    permission="$2"
    remediation="$3"
    current_permission=$(stat -c "%a" "$file")

    if [ "$current_permission" -eq "$permission" ]
    then
        echo "$file is compliant."
    else
        echo "$file is not compliant. Remediation: $remediation"
    fi
}

# Check if IP forwarding is disabled
sysctl_ip_forwarding=$(sysctl net.ipv4.ip_forward | awk '{print $3}')
if [ "$sysctl_ip_forwarding" -eq 0 ]
then
    echo "IP forwarding is disabled."
else
    echo "IP forwarding is not disabled. Remediation: net.ipv4.ip_forward=0."
fi

# Check if ICMP redirects are not accepted
sysctl_icmp_redirects=$(sysctl net.ipv4.conf.all.accept_redirects | awk '{print $3}')
if [ "$sysctl_icmp_redirects" -eq 0 ]
then
    echo "ICMP redirects are not accepted."
else
    echo "ICMP redirects are accepted. Remediation: Command 1:: 'net.ipv4.conf.all.accept_redirects=0' Command 2:: 'net.ipv4.conf.default.accept_redirects=0'."
fi

# Check permissions for specified files
check_permissions "/etc/crontab" 600 "Command 1:: 'chown root:root /etc/crontab' Command 2:: 'chmod og-rwx /etc/crontab'."
check_permissions "/etc/cron.hourly" 700 "Set permissions to 700."
check_permissions "/etc/cron.daily" 700 "Set permissions to 700."
check_permissions "/etc/cron.weekly" 700 "Set permissions to 700."
check_permissions "/etc/cron.monthly" 700 "Set permissions to 700."
check_permissions "/etc/passwd" 644 "Set permissions to 644."
check_permissions "/etc/shadow" 400 "Set permissions to 400."
check_permissions "/etc/group" 644 "Set permissions to 644."
check_permissions "/etc/gshadow" 400 "Set permissions to 400."
check_permissions "/etc/passwd-" 600 "Set permissions to 600."
check_permissions "/etc/shadow-" 600 "Set permissions to 600."
check_permissions "/etc/group-" 600 "Set permissions to 600."
check_permissions "/etc/gshadow-" 600 "Set permissions to 600."

# Check for legacy "+" entries
if grep -qE '^\+.*$' /etc/passwd
then
    echo "Legacy '+' entries found in /etc/passwd. Remediation: Remove legacy '+' entries."
fi
if grep -qE '^\+.*$' /etc/shadow
then
    echo "Legacy '+' entries found in /etc/shadow. Remediation: Remove legacy '+' entries."
fi
if grep -qE '^\+.*$' /etc/group
then
    echo "Legacy '+' entries found in /etc/group. Remediation: Remove legacy '+' entries."
fi

# Check if root is the only UID 0 account
root_count=$(awk -F: '($3 == 0) {print}' /etc/passwd | wc -l)
if [ "$root_count" -eq 1 ]
then
    echo "Only one UID 0 account (root) found."
else
    echo "Multiple UID 0 accounts found. Remediation: Review and remove extra UID 0 accounts."
fi
