#!/bin/bash
#
# sec-tools.sh
# Author: David Roddick
# git clone https://github.com/dgroddick/sec-tools
# Usage: ./sec-tools.sh [option] 
#
# Installs and configures security assessment tools for Linux.
# These are just common tools that I use regularly and is not meant to replace a complete Linux distribution 
# like Kali Linux.
#
# Inspired by PimpMyKali
#
set -e

ARCH=$(uname -m)
VERSION='0.1'

# Logged in user
USER=$(logname)


HTTPSCREENSHOT=https://github.com/breenmachine/httpscreenshot
MASSCAN=https://github.com/robertdavidgraham/masscan
AMASS=github.com/owasp-amass/amass/v4/...@master
SUBFINDER=github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
ASSETFINDER=github.com/tomnomnom/assetfinder
HTTPROBE=github.com/tomnomnom/httprobe@latest 
GOBUSTER=github.com/OJ/gobuster/v3@latest
GOWITNESS=github.com/sensepost/gowitness@latest
WAYBACKURLS=github.com/tomnomnom/waybackurls@latest

SECLISTS=https://github.com/danielmiessler/SecLists.git
HYDRA=https://github.com/vanhauser-thc/thc-hydra.git

source ./term-colours.sh
source ./recon.sh
source ./common.sh

show_usage() {
    echo -e 'Configures a Linux system for Ethical Hacking.\n'
    echo -e 'Usage: sec-tools.sh [OPTION]...\n'
    echo '  -h, --help           show this message and exit'
    echo '  -f, --full           perform full configuration'
    echo '  -v, --version        print version information and exit'
}

check_for_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo -e "\n\n$redminus Script must be run with sudo ./sec-tools.sh or as root\n$reset"
        exit 1
    fi
}

setup_log_files() {
    exec > >(tee /var/log/sec-tools.log)
    exec 5> /var/log/sec-tools.debug.log
    BASH_XTRACEFD=5
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
    sudo dnf -y upgrade
}

addition_tools() {
    install_virtualbox
    install_wireshark
    install_brave
    install_vscode
}


full_install() {
    #check_for_root
    #detect_os
    
    source ./rhel.sh
    echo -e "$greenplus Setting things up... $reset"

    configure_dnf_repos
    update_system    
    base_packages
    # install_container_tools
    install_go
    install_rust
    install_dotnet
    install_nodejs
    install_ansible
    # install_terraform
    # install_gobuster
    # install_gowitness
    # install_amass
    # install_subfinder
    # install_assetfinder
    # install_httprobe
    # install_waybackurls
    # install_wpscan
    # install_seclists
    # install_sqlmap
    # install_wfuzz
    # install_hydra

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