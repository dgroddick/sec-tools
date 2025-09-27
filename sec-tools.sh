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

show_usage() {
    echo -e 'Configures a Linux system for Ethical Hacking and Cyber Security Research.\n'
    echo -e 'Usage: sec-tools.sh\n'
}

update_system() {
    echo -e "$greenplus Updating system"
    sudo dnf -y upgrade
}

## Repo packages
REPO_GROUPS=("security-lab" "development-libs" "c-development" "rpm-development-tools" "container-management" "php")
CORE_TOOLS=("dnf-plugins-core" "python3-devel" "python3-pip" "tcpdump" "git" "kernel-devel" "golang" "rust" "cargo" "ruby-devel")
CLEANING_TOOLS=("bleachbit" "clamav" "clamav-freshclam")
RECON_TOOLS=("netcat" "ffuf" "gobuster" "assetfinder" "subfinder" "httprobe")

## Flatpak tools
ZAP="org.zaproxy.ZAP"
BURP="net.portswigger.BurpSuite-Community"

# SecLists
SECLISTS=https://github.com/danielmiessler/SecLists.git

# RPMFusion
RPMFUSION="https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
RPMFUSION_NONFREE="https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"


configure_dnf_repos() {
    echo -e "$greenplus Setting up RPMFusion $reset"
    sudo dnf install -y $RPMFUSION $RPMFUSION_NONFREE
}

base_install() {
    echo -e "$greenplus Installing required packages $reset"
    sudo dnf group install -y "${REPO_GROUPS[@]}"
    sudo dnf install -y "${CORE_TOOLS[@]}" "${CLEANING_TOOLS[@]}" "${RECON_TOOLS[@]}"
}

webproxy_install() {
    echo -e "$greenplus Installing Web Proxies $reset"

    sudo dnf install -y flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub $ZAP
    flatpak install flathub $BURP
}

recon_tools_install() {
    echo -e "$greenplus Installing extra recon and scanning tools... $reset"
    if [ ! -d "$HOME/tools" ]; then
        mkdir $HOME/tools/
    fi

    echo "export PATH=$PATH:$HOME/go/bin" >> $HOME/.profile && source $HOME/.profile

    source ./extra.sh
    install_gowitness
    install_waybackurls
    install_wpscan
    install_sublist3r
    install_theharvester
    install_sqlmap
    echo -e "$greenplus All done! Happy Hacking!! $reset"
}

seclists_install() {
    echo -e "$greenplus Installing Seclists $reset"
    if [ -d "$HOME/SecLists" ]; then
        echo -e "\nSeclists already installed\n"
    else
        cd /opt && sudo git clone --depth 1 $SECLISTS
    fi
}

everything_install() {
    echo -e "$greenplus Installing everything... $reset"

    if [ ! -d "$HOME/tools" ]; then
        mkdir $HOME/tools/
    fi
    base_install
    webproxy_install
    recon_tools_install
    seclists_install

    echo -e "$greenplus All done! Happy Hacking!! $reset"
}

main() {
    echo "SEC TOOLS"
    echo "==========="
    echo "A toolkit to configure a Fedora Linux Security Research System."

    echo "What do you want to do?"
    echo "1) Install Core Security Tools"
    echo "2) Install Web Proxies"
    echo "3) Install Extra Recon Tools"
    echo "4) Install SecLists"

    echo "> "
    
    read OPT
    case "${OPT}" in
        1)
            base_install
            ;;
        2)  
            webproxy_install
            ;;
        3)
            recon_tools_install
            ;;
        4)
            seclists_install
            ;;
        *)
            echo "Please select a number from 1-4.\n"
    esac
}
main
