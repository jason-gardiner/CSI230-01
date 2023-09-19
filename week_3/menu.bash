#!/bin/bash

# Storyline: Menu for admin, VPN, and Security functions

# Implement the following
# 1) Add another switch with an argument that checks to see if the user exists in the wg0.conf file
# 2) Edit the manage-users.bash script and add the code to delete a user from the wg0.conf file using sed
# 3) Create a menu for security admin tasks that performs the tasks:
#   3a) List open network sockets
#   3b) Check if any user besides root has a UID of 0
#   3c) Check the last 10 logged in users
#   3d) See currently logged in users
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
      invalid_opt()
    ;;
    esac

    admin_menu
  }

function vpn() {

  clear
  
  echo "[A]dd a peer"
  echo "[D]elete a peer"
  echo "[B]ack to admin menu"
  echo "[M]ain menu"
  echo "[E]xit"
  read -p "Please select an option: " choice

  case "$choice" in
    A|a)
    
      bash peer.bash
      tail -6 wg0.conf |less
    
    ;;
    
    D|d) # Create a prompt for the user
    # Call the manage-user.bash
    # Pass the proper switces and arguement to delete the use
    ;;
    
    B|b) admin_menu
    ;;
    
    M|m) menu
    ;;
    
    E|e) exit 0
    ;;
    
    *)
      invalid_opt()
    ;;
  esac

  vpn_menu
}
  # Call the main function
  menu
  
}