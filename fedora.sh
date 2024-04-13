#!/bin/bash
# Tools from the Fedora repos

# Repo packages
CORE_TOOLS=("dnf-plugins-core" "python3-devel" "python3-pip" "tcpdump" "git" "ruby-devel" "kernel-devel")
CLEANING_TOOLS=("bleachbit" "clamav" "clamav-freshclam" "rkhunter" "chkrootkit")
REPO_GROUPS=("Development Tools" "C Development Tools and Libraries" "RPM Development Tools")

# RPMFusion
RPMFUSION="https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
RPMFUSION_NONFREE="https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"


configure_dnf_repos() {
    #os_release=$( detect_os )
    #echo $os_release
    echo -e "$greenplus Setting up RPMFusion $reset"
    dnf install -y $RPMFUSION $RPMFUSION_NONFREE
}

base_packages() {
    echo -e "$greenplus Installing required packages $reset"
    dnf install -y "${CORE_TOOLS[@]}"
    dnf install -y "${CLEANING_TOOLS[@]}"
    dnf group install -y "${REPO_GROUPS[@]}"
}
