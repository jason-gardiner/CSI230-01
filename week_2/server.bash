
#!/bin/bash

# Storyline: Script to create a wireguard server

# What is the user / peer's name
echo -n "What is the peer's name?"
read the_client

# Filename variable
pFile="${the_client}-wg0.conf"

# Determine if config file already exists
if [[ -f "${pFile}" ]]
then
	echo "wg0.conf already exists, would you like to override? (y/n)"
	read user_input
	if [[ "${user_input}" == "n" || "${user_input}" == "N" ]]
	then
		echo "Exiting..."
		exit 0
	elif [[ "${user_input}" == "y" || "${user_input}" == "Y" ]]
	then
		echo "Creating the wireguard configuration file..."
	# If they don't say yes or no, then give an error
	else
		echo "Invalid input"
		exit 1
	fi
fi

# Create a private key
p="$(wg genkey)"
echo "${p}" > /etc/wireguard/server_private.key

# Create a public key
clientPub="$(echo ${p} | wg pubkey)"
echo "${clientPub}" > /etc/wireguard/server_public.key

# Set the addresses
address="10.254.132.0/24"

# Set Server IP Addresses
ServerAddress="10.254.132.1/24"

# Set a listening port
lport="4282"

# Info to be used in client configuration
peerInfo="# ${address} 192.168.241.131:4282 ${clientPub} 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"
# 1: #, 2: For obtaining an IP address for each client.
# 3: Server's actual IP address
# 4: clients will need server public key
# 5: dns information
# 6: determines the largest packet size allowed
# 7: keeping connection alive for
# 8: what traffic to be routed through VPN

# Generate preshared key
pre="$(wg genpsk)"

# Endpoint
end="$(head -1 wg0.conf | awk ' { print $3 } ')"

# Server Public Key
pub="$(head -1 wg0.conf | awk ' { print $4 } ')"

# DNS Servers
dns="$(head -1 wg0.conf | awk ' { print $5 } ')"

# MTU
mtu="$(head -1 wg0.conf | awk ' { print $6 } ')"

# KeepAlive
keep=="$(head -1 wg0.conf | awk ' { print $7 } ')"

echo "${peerInfo}
[Interface]
Address = ${ServerAddress}
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens33 -j MASQUERADE
ListenPort = ${lport}
PrivateKey = ${p}
" > wg0.conf 

# Create Client COnfiguration File
echo "[Interface]
Address = 10.254.132.100/24
DNS = ${dns}
ListenPort = ${lport}
MTU = ${mtu}
PrivateKey = ${p}
[Peer]
AllowedIPs = ${routes}
PersistentKeepalive = ${keep}
PresharedKey = ${pre}
PublicKey = ${pub}
Endpoint = ${end}
" > ${pfile}

# Add our peer configuration to the server config
echo "
# ${the_client} begin
[Peer]
PublicKey = ${clientPub}
PresharedKey = ${pre}
AllowedIPs = 10.254.132.100/32
# ${the_client} end
" | tee -a wg0.conf


