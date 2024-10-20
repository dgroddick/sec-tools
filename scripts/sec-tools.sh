#!/bin/bash
#
# sec-tools.sh
# Author: David Roddick
# git clone https://github.com/dgroddick/sec-tools
# Usage: ./sec-tools.sh [option] 
#
# Installs and configures security assessment tools for Fedora Linux.
# These are just common tools that I use regularly and is not meant to replace a complete Linux distribution 
# like Kali Linux.
#
# Inspired by PimpMyKali but different.
#
set -e

ARCH=$(uname -m)
VERSION='0.1'

# Logged in user
USER=$(logname)

# terminal colours
red=$'\e[1;31m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
yellow=$'\e[1;93m'
white=$'\e[0m'
bold=$'\e[1m'
norm=$'\e[21m'
reset=$'\e[0m'

# status indicators
greenplus='\e[1;33m[++]\e[0m'
greenminus='\e[1;33m[--]\e[0m'
redminus='\e[1;31m[--]\e[0m'
redexclaim='\e[1;31m[!!]\e[0m'
redstar='\e[1;31m[**]\e[0m'

source ./general.sh

show_usage() {
    echo -e 'Configures a Linux system for Ethical Hacking and Cyber Security Research.\n'
    echo -e 'Usage: sec-tools.sh\n'
}

check_for_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo -e "\n\n$redminus Script must be run with sudo ./sec-tools.sh or as root\n$reset"
        exit 1
    fi
}

detect_os() {
    if [ -f /etc/os-release ]; then
        os_name=$(grep '^NAME' /etc/os-release | awk -F= '{ print $2 }')
        os_id="$(. /etc/os-release && echo "$ID")"
        os_version="$(. /etc/os-release && echo "$VERSION_ID")"
	echo $os_id

	if [ "$os_id" == "centos" ];then
	    echo "Loading CentOS tools"
	    source ./centos.sh
	    configure_dnf
	    base_packages
    	elif [ "$os_id" == "fedora" ];then
            echo "Loading Fedora tools..."
	    source ./fedora.sh
	else
            echo "You must be running RHEL... Cool!"
	fi
    else
        echo -e "\n$redminus It is unlikely that you are running a supported Operating System.\n$reset"
        exit 1
    fi
}

update_system() {
    echo -e "$greenplus Updating system"
    sudo dnf -y upgrade
}

#
# Tools for programming
#
install_dev_tools() {
    echo -e "$greenplus Installing Development Tools... $reset"
    source ./dev-tools.sh
    install_go
    install_rust
    install_dotnet
    install_nodejs
    install_vscode
    echo -e "$greenplus All done! Happy Hacking!! $reset"
}

#
# Tools for infrastructure, like Docker and Ansible...
#
install_infra_tools() {
    echo -e "$greenplus Installing Infrastructure Tools... $reset"
    source ./infra-tools.sh
    install_container_tools
    install_ansible
    install_terraform
    echo -e "$greenplus All done! Happy Hacking!! $reset"
}


#
# Tools for recon and scanning
#
install_recon_tools() {
    echo -e "$greenplus Installing recon and scanning tools... $reset"
    source ./recon-tools.sh
    sudo dnf install -y "${SCAN_TOOLS[@]}"
    install_gobuster
    install_gowitness
    install_amass
    install_subfinder
    install_assetfinder
    install_httprobe
    install_waybackurls
    install_wpscan
    install_sublist3r
    install_theharvester
    install_sherlock
    echo -e "$greenplus All done! Happy Hacking!! $reset"
}

#
# Tools for hacking
#
install_hack_tools() {
    echo -e "$greenplus Installing Hacking Tools... $reset"
    source ./hacking-tools.sh
    base_hacking_packages
    install_hydra
    install_wfuzz
    install_sqlmap
    echo -e "$greenplus All done! Happy Hacking!! $reset"
}

#
# Tools for Web hacking
#
install_web_hack_tools() {
    echo -e "$greenplus Installing Web Hacking Tools... $reset"
    source ./web-tools.sh
    install_zap
    echo -e "$greenplus All done! Happy Hacking!! $reset"
}

#
# Tools for Reverse Engineering
#
install_rev_eng_tools() {
    echo -e "$greenplus Installing Reverse Engineering Tools... $reset"
    source ./rev-eng.sh
    install_ghidra
    echo -e "$greenplus All done! Happy Hacking!! $reset"
}

full_install() {
    echo -e "$greenplus Installing everything... $reset"
    install_dev_tools
    install_infra_tools
    install_recon_tools
    install_hack_tools
    install_web_hack_tools
    install_rev_eng_tools
    install_seclists
    echo -e "$greenplus All done! Happy Hacking!! $reset"
}

main() {
    detect_os

    echo "SEC TOOLS"
    echo "==========="
    echo "A toolkit to configure a Fedora/CentOS Linux Security Research System."

    echo "What do you want to do?"
    echo "1) Install Development Tools"
    echo "2) Install Infrastructure Tools"
    echo "3) Install Recon and Scanning Tools"
    echo "4) Install Linux Hacking Tools"
    echo "5) Install Web Hacking Tools"
    echo "6) Install Reverse Engineering Tools"
    echo "7) Install Everything"
    echo "> "
    
    read OPT
    case "${OPT}" in
        1)
            install_dev_tools
            ;;
        2)  
            install_infra_tools
            ;;
        3)
            install_recon_tools
            ;;
        4)
            install_hack_tools
            ;;
        5)
            install_web_hack_tools
            ;;
        6)
            install_rev_eng_tools
            ;;
        7)
            full_install
            ;;
        *)
            echo "Please select a number from 1-7.\n"
    esac
}
main
