# !/bin/bash

function checks() {

	echo ""
if [[ $2 != $3 ]]
then

	echo "The $1 is not compliant"
	echo "The current policy should be: $2"
	echo "The current value is: $3"
else
	echo "The $1 is compliant"
	echo "Current Value: $3"
fi
}

function doublecheck() {
        echo ""
if [[ $1 != $2 ]]
then
        echo "1"
fi
}

pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2} ')
checks "Password Max Days" "365" "${pmax}"

pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2} ')
checks "Password Minimum Days" "14" "${pmin}"

pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2} ')
checks "Password Warn Age" "7" "${pwarn}"

chkSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 } ')
checks "SSH UsePAM" "yes" "${chkSSHPAM}"

echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk ' { print $3 } ')
do

	chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 } ')
	checks "Home directory ${eachDir}" "drwx------" "${chDir}"

done

ipfor=$(sysctl net.ipv4.ip_forward)
checks "IP Forwarding" "net.ipv4.ip_forward = 0" "${ipfor}"

if [[ "${ipfor}" != "net.ipv4.ip_forward = 0" ]]
then
	echo "Remiediation:"
	echo "Set the following parameter in /etc/sysctl.conf or an /etc/sysctl.d/* file:"
	echo "\"net.ipv4.ip_forward = 0\""
	echo ""
	echo "Then run the following commands:"
	echo "# sysctl -w net.ipv4.ip forward=0"
	echo "# sysctl -w net.ipv4.route.flush=1"
fi

ICMPre1=$(sysctl net.ipv4.conf.all.accept_redirects)
ICMPre2=$(sysctl net.ipv4.conf.default.accept_redirects)
checks "ICMP Redirects" "net.ipv4.conf.all.accept_redirects = 0" "${ICMPre1}"
checks "ICMP Redirects" "net.ipv4.conf.default.accept_redirects = 0" "${ICMPre2}"

if [[ "${ICMPre1}" != "net.ipv4.conf.all.accept_redirects = 0" || "${ICMPre2}" != "net.ipv4.conf.default.accept_redirects = 0" ]]
then
	echo ""
	echo "Remediation:"
	echo "Set the following parameters in /etc/sysctl.conf or an /etc/sysctl.d/* file:"
	echo "net.ipv4.conf.all.accept_redirects = 0"
	echo "net.ipv4.conf.default.accept_redirects = 0"

	echo "Then run the following commands:"
	echo "# sysctl -w net.ipv4.conf.all.accept_redirects=0"
	echo "# sysctl -w net.ipv4.conf.default.accept_redirects=0"
	echo "# sysctl -w net.ipv4.route.flush=1"
fi

# defining a check for all cron files

function croncheck()
{
false=0
cron1=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $5 } ')
cron2=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $6 } ')
checks "$1 permissions" "0/" "${cron1}"
checks "$1 permissions" "root)" "${cron2}"
if [[ "${cron1}" != "0/" || "${cron2}" != "root)" ]]
then
	false=1
fi
cron1=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $9 } ')
cron2=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $10 } ')
if [[ "${cron1}" != "0/" || "${cron2}" != "root)" ]]
then
	false=1
fi

checks "$1 permissions" "0/" "${cron1}"
checks "$1 permissions" "root)" "${cron2}"

if [[ false == 1 ]]
then
	echo "Remediation:"
	echo "Run the following commands:"
	echo "chown root:root /etc/$1"
	echo "chmod og-rwx /etc/$1"
fi
false=0
}

# checking cron files

croncheck "crontab"
croncheck "cron.hourly"
croncheck "cron.daily"
croncheck "cron.weekly"
croncheck "cron.monthly"

# checking passwd or group

function passgroupcheck() {
false=0
pass1=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $5 } ')
pass2=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $6 } ')
checks "$1 permissions" "0/" "${pass1}"
checks "$1 permissions" "root)" "${pass2}"
if [[ "${pass1}" != "0/" || "${pass2}" != "root)" ]]
then
        false=1
fi
pass1=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $9 } ')
pass2=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $10 } ')
if [[ "${pass1}" != "0/" || "${pass2}" != "root)" ]]
then
        false=1
fi
checks "$1 permissions" "0/" "${pass1}"
checks "$1 permissions" "root)" "${pass2}"

pass1=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $2 } ')
checks "$1 permissions" "(0644/-rw-r--r--)" "${pass1}"
if [[ "${pass1}" != "(0644/-rw-r--r--)" ]]
then
        false=1
fi

if [[ false == 1 ]]
then
        echo "Remediation:"
        echo "Run the following commands:"
        echo "chown root:root /etc/$1"
        echo "chmod 644 /etc/$1"
fi
false=0
}

# Checking with function
passgroupcheck "passwd"
passgroupcheck "group"
passgroupcheck "passwd-"
passgroupcheck "group-"

# checking shadow
function shadowchecker() {
false=0
shad1=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $5 } ')
shad2=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $6 } ')
checks "$1 permissions" "0/" "${shad1}"
checks "$1 permissions" "root)" "${shad2}"
if [[ "${shad1}" != "0/" || "${shad2}" != "root)" ]]
then
        false=1
fi

shad1=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $9 } ')
shad2=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $10 } ')
if [[ "${shad1}" != "42/" || "${shad2}" != "shadow)" ]]
then
        false=1
fi
checks "$1 permissions" "42/" "${shad1}"
checks "$1 permissions" "shadow)" "${shad2}"

shad1=$(stat /etc/$1 | egrep -i "Uid" | awk ' { print $2 } ')
checks "$1 permissions" "(0640/-rw-r-----)" "${shad1}"
if [[ "${shad1}" != "(0640/-rw-r-----)" ]]
then
        false=1
fi
if [[ false == 1 ]]
then
        echo "Remediation:"
        echo "Run the following commands:"
        echo "chown root:shadow /etc/$1"
        echo "chmod o-rwx,g-wx /etc/$1"
fi
false=0
}

shadowchecker "shadow"
shadowchecker "gshadow"
shadowchecker "shadow-"
shadowchecker "gshadow-"

function checklegacy() {

entries=$(grep '^\+:' /etc/$1)
if [[ "${entries}" != "" ]]
then
	echo "There are legacy \"+\" entries in /etc/$1, please remove them"
else
	echo "There are no legacy \"+\" entries in /etc/$1"
fi

}

checklegacy "passwd"
checklegacy "shadow"
checklegacy "group"

rootcheck=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')
if [[ "${rootcheck}" == "root" ]]
then
	echo "Root is the only user with UID 0"
else
	echo "Root is not the only user with UID 0, please remove other users with UID 0"
fi
