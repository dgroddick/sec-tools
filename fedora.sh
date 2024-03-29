#!/bin/bash
# Fedora specific tools

# Repo packages
REPO_TOOLS=("dnf-plugins-core" "python3-devel" "python3-pip" "tcpdump" "git" "ruby-devel" "kernel-devel")
REPO_GROUPS=("Development Tools" "C Development Tools and Libraries" "RPM Development Tools" "Virtualization")
SCAN_TOOLS=("nmap" "netcat" "nikto" "john" "ffuf")

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
    echo -e "$greenplus Installing required required packages $reset"
    sudo dnf install -y "${REPO_TOOLS[@]}" "${SCAN_TOOLS[@]}"
    sudo dnf group install -y "${REPO_GROUPS[@]}"
}
