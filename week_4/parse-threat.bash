#!/bin/bash

# Storyline: Extract IPs from emergingthreats.net and create a firewall ruleset

# Regex to extract the networks
# 5.134.128.0/19

# If the file exists, don't download it
pFile="/tmp/emerging-drop.suricata.rules"
if [[ -f "${pFile}" ]]
then 
	# Prompt if we need to overwrite the file
  echo "The file ${pFile} already exists."
	echo -n "Do you want to overwrite it? [y|n] "
	read to_overwrite

	if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" || "${to_overwrite}" == "n"  ]]
	then
		echo "Proceeding with current ${pFile} file..."
	elif [[ "${to_overwrite}" == "y" ]]
	then
		echo "Creating the emerging threats file..."
    wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules
	# If they don't specify y/N then error
	else
		echo "Invalid value"
		exit 1
	fi
fi

egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

# Select output type\
function chooseOutputType() {
	clear
 
	echo "[I]ptables"
 	echo "[C]isco"
  	echo "[P]arse Cisco"
 	echo "[W]indows Firewall"
 	echo "[M]ac OS X"
  	echo "[E]xit"
   	read -p "Please enter an output type: " choice
  
	case "${choice}" in
 		I|i)
  		 # Create a Firewall ruleset
		for eachIP  in $(cat badIPs.txt)
		do
 			 echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPS.iptables
		done
  		echo "Firewall Ruleset Created..."
    		sleep 2
   		;;
     
   		C|c)
     		# Create a Firewall ruleset
		egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0' badIPs.txt | tee badips.nocidr
    		for eachip in $(cat badips.nocidr)
    		do
        		echo "deny ip host ${eachip} any" | tee -a badips.cisco
    		done
    		rm badips.nocidr
    		echo 'Created IP Tables for firewall drop rules in file "badips.cisco"'
    		sleep 2
     		;;
       
       		P|p)
	 	# Download new file
	 	wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv
    		awk '/domain/ {print}' /tmp/targetedthreats.csv | awk -F \" '{print $4}' | sort -u > threats.txt
    		echo 'class-map match-any BAD_URLS' | tee ciscothreats.txt
    		for eachip in $(cat threats.txt)
    		do
        		echo "match protocol http host \"${eachip}\"" | tee -a ciscothreats.txt
		done
    		rm threats.txt
    		echo 'Cisco URL filters file successfully parsed and created at "ciscothreats.txt"'
    		sleep 2
	 	;;
   
     		W|w)
            	# Create a Firewall ruleset
		for eachIP  in $(cat badIPs.txt)
		do
 			 echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${eachip}\" dir=in action=block remoteip=${eachip}" | tee -a badips.netsh
		done
  		echo "Firewall Ruleset Created..."
    		sleep 2
       		;;
	 
       		M|m)
	      	# Create a Firewall ruleset
		for eachIP  in $(cat badIPs.txt)
		do
 			 echo "block in from $(eachIP) to any" | tee -a pf.conf
		done
  		echo "Firewall Ruleset Created..."
    		sleep 2
	 	;;
   
   		E|e) exit 0
     		;;
       		*)
	 	echo ""
   		echo "Invalid option"
     		echo ""
       		sleep 2
	 	;;
   	esac
    	chooseOutputType
}

chooseOutputType


