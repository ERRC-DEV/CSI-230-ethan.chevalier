#!/bin/bash

# Function menu

function menu ()
{
	clear
	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	read -p "Select an option: " selection

	case "$selection" in

	1) admin_menu
	;;
	2) security_menu
	;;
	3) exit 0
	;;
	*)
		echo "Invalid option"
		sleep 2

		menu
	;;
	esac
	menu
}


function admin_menu()
{

	clear
	echo "[1] List Running Processes"
	echo "[2] Network Sockets"
	echo "[3] VPN Menu"
	echo "[4] exit"
	read -p "Select an option: " selection

	case "$selection" in

	1) ps -ef |less
	;;
	2) netstat -an --inet |less
	;;
	3) vpn_menu
	;;
	4) exit 0
	;;
	*)
                echo "Invalid option"
                sleep 2

                admin_menu
        ;;

	esac
	admin_menu
}


function vpn_menu()
{
	clear
	echo "[1] Add User"
	echo "[2] Delete User"
	echo "[3] Check if User Exists"
	echo "[4] Back"
	echo "[5] Back to Main"
	echo "[6] Exit"
	read -p "Select an option: " selection

	case "$selection" in

	1) bash peer.bash
	;;
	2)
		read -p "Which user will be deleted? " user
		bash manage-users.bash -d -u "$user"
	;;
	3)
		read -p "Which user would you like to check for? " user
		bash manage-users.bash -c -u ${user}
		sleep 3
	;;
	4) admin_menu
	;;
	5) menu
	;;
	6) exit 0
	;;
	*)
		echo "Invalid option"
		sleep 2
		vpn_menu
	;;
	esac

	vpn_menu
}

function security_menu()
{
	clear
	echo "[1] Open Network Sockets"
	echo "[2] UID"
	echo "[3] Check the last 10 logged in users"
	echo "[4] Logged in users"
	echo "[5] Block List Menu"
	echo "[6] Back"
	echo "[7] Exit"
	read -p "Select an option: " selection

	case "$selection" in
	1) netstat -1 |less
	;;
	2) cat /etc/passwd | grep "x:0" |less
	;;
	3) last -n 10 |less
	;;
	4) who |less
	;;
	5) bash /home/ethan/Repository/CSI-230-ethan.chevalier/Week4/parse-threat.bash
	;;
	6) menu
	;;
	7) exit 0
	;;
	esac

	security_menu
}

menu
