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
 	echo "[W]indows Firewall"
 	echo "[M]ac OS X"
  	echo "[E]xit"
   	read -p "Please enter an output type: " choice
  
	case "${choice}" in
 		I|i)
  		 # Create a Firewall ruleset
		for eachIP  in $(cat badIPs.txt)
		do

 			 # On a mac
 			 #echo "block in from $(eachIP) to any" | tee -a pf.conf
  
 			 echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPS.iptables
  
		done
   		;;
   		C|c)
     		# Create a Firewall ruleset
		for eachIP  in $(cat badIPs.txt)
		do
 			 echo "cisco -A INPUT -s ${eachIP} -j DROP" | tee -a badIPS.cisco
		done
     		;;
     		W|w)
            	# Create a Firewall ruleset
		for eachIP  in $(cat badIPs.txt)
		do
 			 echo "windows firewall -A INPUT -s ${eachIP} -j DROP" | tee -a badIPS.windowsfirewall
		done
       		;;
       		M|m)
	      	# Create a Firewall ruleset
		for eachIP  in $(cat badIPs.txt)
		do
 			 echo "Mac OS X -A INPUT -s ${eachIP} -j DROP" | tee -a badIPS.macosx
		done
	 	;;
   		E|e) exit 0
     		;;
       		*)
	 	;;
   	esac
    	chooseOutputType
}


