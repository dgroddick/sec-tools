#!/bin/bash
# RHEL specific tools

# Repo packages
REPO_TOOLS=("dnf-plugins-core" "python3-devel" "python3-pip" "tcpdump" "git" "ruby-devel" "kernel-devel")
REPO_GROUPS=("Development Tools" "Debugging Tools" "RPM Development Tools")
VIRT_TOOLS=("qemu-kvm" "libvirt" "virt-install" "virt-viewer" "virt-manager")

SCAN_TOOLS=("nmap" "netcat" "nikto" "john" "ffuf")

# EPEL
EPEL="https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm"

# RPMFusion
RPMFUSION="https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm"
RPMFUSION_NONFREE="https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm"

configure_dnf_repos() {
    echo -e "$greenplus Setting up EPEL $reset"
    sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

    echo -e "$greenplus Setting up Codeready Builder $reset"
    sudo subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms

    echo -e "$greenplus Setting up RPMFusion $reset"
    sudo dnf install -y $RPMFUSION $RPMFUSION_NONFREE
}

base_packages() {
    echo -e "$greenplus Installing required base packages $reset"
    for pkg in "${REPO_TOOLS[@]}"; do
        sudo dnf install -y "${pkg}"
    done

    echo -e "$greenplus Installing development groups $reset"
    for pkg in "${REPO_GROUPS[@]}"; do
        sudo dnf group install -y "${pkg}"
    done
}

setup_virtualization() {
    echo -e "$greenplus Installing packages for virtualization $reset"
    for pkg in "${VIRT_TOOLS[@]}"; do
        dnf install -y "${pkg}"
    done 
}








