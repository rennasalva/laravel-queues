#!/bin/bash

function help_msg(){
        cat <<EOF
Usage:
        deployment.sh [roleName] [--nginx|--apache] --zpkFile <LOCAL_PATH_TO_ZPK_FILE>

        Example: deployment.sh WordpressApp --nginx
EOF
}

if [ "$#" == "0" ]
then
        help_msg
        exit 1
fi

app=$1
webserver="nginx" 
zpkFile=""

while [[ "$#" -gt 1 ]]
do
        case $2 in
        --nginx)
                webserver="nginx"
                shift
                ;;
        --apache)
                webserver="apache"
                shift
                ;;
        --zpkFile)
                zpkFile=$3
		shift 2
		;;
        *)
#               echo "unknown parameter $2"
#               exit 2
                ;;
        esac
done

if [ -d roles/$app ];
then 
	echo "Executing Ansible role  $app:"
	ansible-playbook -i inventory.yml playbook.yml --extra-vars "roleName=$app webserver=$webserver zpkFile=$zpkFile"
else
	echo "Executing Ansible playbook $app:"
	ansible-playbook -i inventory.yml $app --extra-vars "webserver=$webserver zpkFile=$zpkFile"
fi
