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

source ./fedora.sh
source ./general.sh
source ./dev-tools.sh
source ./infra-tools.sh
source ./recon-tools.sh
source ./hacking-tools.sh

show_usage() {
    echo -e 'Configures a Linux system for Ethical Hacking.\n'
    echo -e 'Usage: sec-tools.sh [OPTION]...\n'
    echo '  -h, --help           show this message and exit'
    echo '  -d, --dev            install programming and development tools'
    echo '  -i, --infra          install infrastructure tools'
    echo '  -f, --full           perform full configuration'
    echo '  -v, --version        print version information and exit'
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

        if [ "$os_id" != "rhel" ] || [ "$os_id" != "fedora" ];then 
            echo -e "$redminus Looks like you're not running a supported Linux distribution. Sorry"
            exit 1
        fi
    else
        echo -e "\n$redminus It is unlikely that you are running a supported Operating System.\n$reset"
        exit 1
    fi
}

update_system() {
    echo -e "$greenplus Updating system"
    dnf -y upgrade
}

#
# Tools for programming
#
install_dev_tools() {
    echo -e "$greenplus Installing Development Tools... $reset"

    configure_dnf_repos
    update_system    
    base_packages
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
    configure_dnf_repos
    update_system    
    base_packages

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
    configure_dnf_repos
    update_system    
    base_packages

    dnf install -y "${SCAN_TOOLS[@]}"

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

    install_wireshark

    echo -e "$greenplus All done! Happy Hacking!! $reset"
}

#
# Tools for hacking
#
install_hack_tools() {
    echo -e "$greenplus Installing Hacking Tools... $reset"
    configure_dnf_repos
    update_system    
    base_packages

    base_hacking_packages
    install_hydra
    install_wfuzz
    install_sqlmap

    echo -e "$greenplus All done! Happy Hacking!! $reset"
}

full_install() {
    echo -e "$greenplus Installing everything... $reset"
    configure_dnf_repos
    update_system    
    base_packages
    
    install_dev_tools
    install_infra_tools
    install_recon_tools
    install_hack_tools

    install_wireshark
    install_seclists

    echo -e "$greenplus All done! Happy Hacking!! $reset"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    for opt in "$@"; do
        case ${opt} in
        -h | --help)
            show_usage
            exit 0
            ;;
        -f | --full)
            full_install
            ;;
        -d | --dev)
            install_dev_tools
            ;;
        -i | --infra)
            install_infra_tools
            ;;
        -r | --recon)
            install_recon_tools
            ;;
        -x | --hack)
            install_infra_tools
            ;;
        -v | --version)
            echo "${VERSION}"
            exit 0
            ;;
        *)
            echo "Error: unknown option ${opt}" >&2
            exit 2
            ;;
        esac
    done
fi
