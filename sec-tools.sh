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
CORE_TOOLS=("dnf-plugins-core" "python3-devel" "python3-pip" "tcpdump" "git" "kernel-devel" "golang" "rust" "cargo" "ruby-devel")
CLEANING_TOOLS=("bleachbit" "clamav" "clamav-freshclam" "rkhunter" "chkrootkit")
REPO_GROUPS=("Development Tools" "C Development Tools and Libraries" "RPM Development Tools")
HACK_TOOLS=("hydra" "john")
CONTAINER=("podman" "podman-compose" "podman-docker" "skopeo" "buildah")
RECON_TOOLS=("nmap" "netcat" "ffuf" "gobuster" "assetfinder" "subfinder" "httprobe")

# SecLists
SECLISTS=https://github.com/danielmiessler/SecLists.git

# RPMFusion
RPMFUSION="https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
RPMFUSION_NONFREE="https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"


configure_dnf_repos() {
    #os_release=$( detect_os )
    #echo $os_release
    echo -e "$greenplus Setting up RPMFusion $reset"
    sudo dnf install -y $RPMFUSION $RPMFUSION_NONFREE
}

base_packages() {
    echo -e "$greenplus Installing required packages $reset"
    sudo dnf install -y "${CORE_TOOLS[@]}"
    sudo dnf install -y "${CLEANING_TOOLS[@]}"
    sudo dnf group install -y "${REPO_GROUPS[@]}"
    sudo dnf install -y "${HACK_TOOLS[@]}"
    sudo dnf install -y "${CONTAINER[@]}"
    sudo dnf install -y "${SCAN_TOOLS[@]}"
}

#
# Tools for recon and scanning
#
install_recon_tools() {
    echo -e "$greenplus Installing recon and scanning tools... $reset"
    source ./recon-tools.sh
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
    echo -e "$greenplus All done! Happy Hacking!! $reset"
}


install_seclists() {
    echo -e "$greenplus Installing Seclists $reset"
    if [ -d /opt/SecLists ]; then
        echo -e "\nSeclists already installed\n"
    else
        cd /opt && sudo git clone --depth 1 $SECLISTS
    fi
}

full_install() {
    echo -e "$greenplus Installing everything... $reset"

    configure_dnf_repos
    base_packages
    install_recon_tools
    install_seclists

    echo -e "$greenplus All done! Happy Hacking!! $reset"
}

main() {
    echo "SEC TOOLS"
    echo "==========="
    echo "A toolkit to configure a Fedora Linux Security Research System."

    full_install
}
main
