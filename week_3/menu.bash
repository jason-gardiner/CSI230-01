#!/bin/bash

# Storyline: Menu for admin, VPN, and Security functions

# Implement the following
# 1) Add a Check if User Exists in VPN Menu
# DONE 2) Edit the manage-users.bash script and add the code to delete a user from the wg0.conf file using sed
# DONE 3) Create a menu for security admin tasks that performs the tasks:
#   DONE 3a) List open network sockets
#   DONE 3b) Check if any user besides root has a UID of 0
#   DONE 3c) Check the last 10 logged in users
#   DONE 3d) See currently logged in users
# 4) Create a new user and add the menu as their shell

function invalid_opt() {
  echo ""
      echo "Invalid option"
      echo""
      sleep 2
}

function menu() {
  # clears the screen
  clear

  echo "[A]dmin Menu"
  echo "[S]ecurity Menu"
  echo "[E]xit"
  read -p "Please enter a choice above: " choice

  case "$choice" in 
    A|a) admin_menu
    ;;
     
    S|s) security_menu
    ;;
      
    E|e) exit 0
    ;;
      
    *)
      invalid_opt
      
      # Call the main menu
      menu
	;;
  esac
}

function security_menu() {

  clear

  echo "[L]ist Open Network Sockets"
  echo "[U]ser UID"
  echo "[R]ecent 10 Users Logged In"
  echo "[C]urrently Logged In Users"
  echo "[M]ain Menu"
  echo "[E]xit"
  read -p "Please enter a choice above: " choice

  case "$choice" in

  L|l) netstat -l |less
  ;;

  U|u) cat /etc/passwd | grep "x:0" | less
  ;;

  R|r) last -n 10 | less
  ;;

  C|c) who | less
  ;;
  
  M|m) menu
  ;;

  E|e) exit 0
  ;;

  *)
    invalid_opt
  ;;
  esac

  security_menu

}

function admin_menu() {

  clear
   
  echo "[L]ist Running Processes"
  echo "[N]etwork Sockets"
  echo "[V]PN Menu"
  echo "[M]ain menu"
  echo "[E]xit"
  read -p "Please enter a choice above: " choice

  case "$choice" in

  L|l) ps -ef |less
  ;;

  N|n) netstat -an --inet |less
  ;;

  V|v) vpn_menu
  ;;

  M|m) menu
  ;;

  E|e) exit 0
  ;;

  *)
    invalid_opt
  ;;
  esac

  admin_menu
}

function vpn_menu() {

  clear
  
  echo "[A]dd a peer"
  echo "[D]elete a peer"
  echo "[C]heck a peer"
  echo "[B]ack to admin menu"
  echo "[M]ain menu"
  echo "[E]xit"
  read -p "Please select an option: " choice

  case "$choice" in
    A|a)
    
      bash peer.bash
      tail -6 wg0.conf |less
    
    ;;
    
    D|d)
    	read -p "What is the name of the user you would like to delete: " username
    	bash manage-users.bash -d -u $username
     	sleep 2
    ;;

    C|c)
    	read -p "What is the name of the user you would like to check: " username
	search=$(cat wg0.conf | grep ${username})
	if [[ ${search} != ""  ]]
	then
 		echo "The user ${username} exists."
	else
		echo "The user ${username} does not exist."
	fi
 	echo ""
 	read -p "Press enter to proceed" temp
    ;;
    
    B|b) admin_menu
    ;;
    
    M|m) menu
    ;;
    
    E|e) exit 0
    ;;
    
    *)
      invalid_opt
    ;;
  esac

  vpn_menu
}
  # Call the main function
  menu
  
}
