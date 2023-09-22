#!/bin/bash

# Add and delete peers

while getopts 'hdau:c' OPTION ; do

	case "$OPTION" in

	d) u_del=${OPTION}
	;;
	a) u_add=${OPTION}
	;;
	u) t_user=${OPTARG}
	;;
	h)
		echo ""
		echo "Usage: $(basename $0) [-a]|[-d] -u username"
		echo ""
		exit 1
	;;
	c) u_check=${OPTION}
	;;
	*)
		echo "Invalid value"
		exit 1
	;;
	esac

done

# check if -a and -d are both empty or both specified.

if [[ (${u_del} == "" && ${u_add} == "" && ${u_check} == "") || (${u_del} != "" && ${u_add} != "") ]]
then

	echo "Please specify -a or -d and the -u username"
	exit 1
fi

# check if -u is specified

if [[ (${u_del} != "" || ${u_add} != "" || ${u_check} != "") && ${t_user} == "" ]]
then

	echo "Please specify a user (-u)"
	exit 1
fi

# delete
if [[ ${u_del} ]]
then
	echo "Deleting user"
	sed -i "/# ${t_user} begin/,/# ${t_user} end/d" wg0.conf
fi

# add
if [[ ${u_add} ]]
then
	echo "Creating user"
	bash peer.bash ${t_user}
fi
# Check to see if a user exists
if [[ ${u_check}  ]]
then
	result=$(cat wg0.conf | grep ${t_user})
	if [[ ${result} != ""  ]]
	then
		echo "The user ${t_user} exists."
	else
		echo "The user ${t_user} does not exist."
	fi
fi
