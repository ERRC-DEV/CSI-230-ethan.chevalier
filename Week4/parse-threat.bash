# !/bin/bash

# ////////////////////
# FUNCTIONS START HERE
# ////////////////////


# Allows user to select which firewall they would like to format for and
# generates the proper blocklist

function menu ()
{
	clear
	echo "[1] IPtables"
	echo "[2] Mac X"
	echo "[3] Windows"
	echo "[4] Cisco"
	echo "[5] Test file"
	echo "[6] Exit"
	read -p "Select an option: " selection

	case "$selection" in

	1)
		for eachIP in $(cat badIPs.txt)
		do
			echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
		done
	;;
	2)
		echo '
scrub-anchor "com.apple/*"
nat-anchor "com.apple/*"
rdr-anchor "com.apple/*"
dummynet-anchor "com.apple/*"
anchor "com.apple/*"
load anchor "com.apple" from "/etc/pf.anchors/com.apple"

		' | tee pf.conf
		for eachIP in $(cat badIPs.txt)
                do
			echo "block in from ${eachIP} to any" | tee -a pf.conf
		done
	;;
	3)
		for eachIP in $(cat badIPs.txt)
                do
                        echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${eachIP}\" dir=in action=block remoteip=${eachIP}" | tee -a badips.netsh
                done
	;;
	4)
		for eachIP in $(cat badIPs.txt)
		do
		echo "deny ip host ${eachIP} any" | tee -a badips.cisco
		done
	;;
	5)
		# echo "class-map match-any BAD_URLS" | tee -a testbadips.cisco
		# wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv
		# echo $(/tmp/targetedthreats.csv | grep "domain") | tee -a testbadips.txt
		# sleep 3
		# cat testbadips.txt | less
		echo "Broken and could not figure out how to fix"
	;;
	6) exit 0
	;;
	*)
		echo "Invalid option"
		sleep 2

		menu
	;;
	esac
	menu
}

# ////////////////
# CODE STARTS HERE
# ////////////////


# Prepping badIPs file

if [[ -f "emerging-drop.suricata.rules" ]]
then
	echo "The threat file already exists."
	echo "Would you like to redownload and update the file? [y|N]"
	read to_update

	if [[ "${to_update}" == "N" || "${to_update}" == "" || "${to_update}" == "n"  ]]
	then
		echo "Proceeding with current file"
	elif [[ "${to_update}" == "y" ]]
	then
		wget http://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules
	fi
fi

egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

# Launching the manu

menu
