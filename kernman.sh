#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

function logo()
{	echo " _____             _____         "
	echo "|  |  |___ ___ ___|     |___ ___ "
	echo "|    -| -_|  _|   | | | | .'|   |"
	echo "|__|__|___|_| |_|_|_|_|_|__,|_|_|"
	printf "\nKernMan - Kernel Management Assistant.\n"
	}  
	
logo	

function usage()
{	printf "\nKernMan is a script written for the purpose of simplifying Kernel Management.
	
Select the option 'List' to display all installed kernels Select the option 'Purge' to display 
all kernels that can be removed and subsequently do so\n\n"
	}
	
	
	
PS3='Please enter your choice: '
options=("Usage" "List" "Purge" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Usage")
	    usage
            ;;
        "List")
            dpkg -l linux-image-\* | grep ^ii
            ;;
        "Purge")
            kernelver=$(uname -r | sed -r 's/-[a-z]+//')
            dpkg -l linux-{image,headers}-"[0-9]*" | awk '/ii/{print $2}' | grep -ve $kernelver
            
            printf "\nThese items will be deleted.\n"
            read -p 'Continue? Y/n ' choice
            
            if [[ $choice == "y" ]]; then
		sudo apt-get purge $(dpkg -l linux-{image,headers}-"[0-9]*" | awk '/ii/{print $2}' | grep -ve "$(uname -r | sed -r 's/-[a-z]+//')")
	    else
		echo "Aborted"
		break
		exit 1
	    fi
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
