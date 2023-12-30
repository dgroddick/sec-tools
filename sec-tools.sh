#!/bin/bash
#
# sec-tools.sh
# Author: David Roddick
# git clone https://github.com/dgroddick/sec-tools
# Usage: sudo ./sec-tools.sh [option] 
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

# Repo packages
REPO_TOOLS=("dnf-plugins-core" "python3-devel" "python3-pip" "nmap" "netcat" "nikto" "john" "ffuf" "tcpdump" "git" 
            "ruby-devel" "binutils" "kernel-devel" "kernel-headers"  "glibc-headers" "glibc-devel" "dkms")
#REPO_GROUPS=("Development Tools" "Debugging Tools" "RPM Development Tools" "Virtualization")
REPO_GROUPS=("Development Tools" "C Development Tools and Libraries" "RPM Development Tools" "Virtualization")
#VIRT_TOOLS=("qemu-kvm" "libvirt" "virt-install" "virt-viewer" "virt-manager")

# External Tools
HTTPSCREENSHOT=https://github.com/breenmachine/httpscreenshot
MASSCAN=https://github.com/robertdavidgraham/masscan
AMASS=github.com/owasp-amass/amass/v4/...@master
SUBFINDER=github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
ASSETFINDER=github.com/tomnomnom/assetfinder
HTTPROBE=github.com/tomnomnom/httprobe@latest 
HYDRA=https://github.com/vanhauser-thc/thc-hydra.git
GOBUSTER=github.com/OJ/gobuster/v3@latest
GOWITNESS=github.com/sensepost/gowitness@latest
WAYBACKURLS=github.com/tomnomnom/waybackurls@latest
SECLISTS=https://github.com/danielmiessler/SecLists.git

show_usage() {
    echo -e 'Configures a Linux system for Ethical Hacking.\n'
    echo -e 'Usage: sec-tools.sh [OPTION]...\n'
    echo '  -h, --help           show this message and exit'
    echo '  -f, --full           perform full configuration'
    echo '  -v, --version        print version information and exit'
}

check_for_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo -e "\n\n$redminus Script must be run with sudo ./sec-tools.sh or as root\n"
        exit
    fi
}

setup_log_files() {
    exec > >(tee /var/log/sec-tools.log)
    exec 5> /var/log/sec-tools.debug.log
    BASH_XTRACEFD=5
}

detect_os () {
    if [ -f /etc/os-release ]; then
        os_name=$(grep '^NAME' /etc/os-release | awk -F= '{ print $2 }')
        os_id="$(. /etc/os-release && echo "$ID")"
        os_version="$(. /etc/os-release && echo "$VERSION_ID")"
        echo $os_id
    else
        echo -e "\n$redminus It is unlikely that you are running a supported Operating System.\n"
    fi
    # case "$os_id" in
    
    #     rhel)
    #         echo "You're running Red Hat"
    #         ;;

    #     centos)
    #         echo "You're running CentOS"
    #         ;;

    #     ol)
    #         echo "Oracle Linux"
    #         ;;
    # esac
}

configure_dnf_repos() {
    echo -e "$greenplus Detecting OS Version"
    os_release=$( detect_os )

    echo $os_release
}

update_system() {
    echo -e "$greenplus Updating system"
    sudo dnf -y upgrade
}

base_packages() {
    echo -e "$greenplus Installing required base packages"
    for pkg in "${REPO_TOOLS[@]}"; do
        sudo dnf install -y "${pkg}"
    done

    echo -e "$greenplus Installing development groups"
    for pkg in "${REPO_GROUPS[@]}"; do
        sudo dnf group install -y "${pkg}"
    done
}

setup_virtualization() {
    echo -e "$greenplus Installing packages for virtualization"
    for pkg in "${VIRT_TOOLS[@]}"; do
        dnf install -y "${pkg}"
    done 
}

install_virtualbox() {
    echo -e "$greenplus Installing VirtualBox"
    if [ $(which virtualbox ) ]; then
        echo -e "\nVirtualBox is already installed\n"
    else
        sudo dnf config-manager --add-repo=https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
        sudo rpm --import https://www.virtualbox.org/download/oracle_vbox_2016.asc
        sudo dnf install VirtualBox-7.0 -y
        sudo usermod -aG vboxusers $USER
        sudo newgrp vboxusers
    fi
}

install_wireshark() {
    echo -e "$greenplus Installing Wireshark"
    if [ $(which wireshark) ]; then
        echo -e "\nWireshark is already installed\n"
    else
        sudo dnf install -y wireshark
    fi
}

install_brave() {
    echo -e "$greenplus Installing Brave Browser"
    if [ $(which brave-browser) ]; then
        echo -e "\nBrave Browser is already installed\n"
    else
        sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
        sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
        sudo dnf install -y brave-browser
    fi
}

install_go() {
    echo -e "$greenplus Installing Go"
    if [ $(which go) ]; then
        echo -e "\nGo is already installed\n"
    else
        #if [ ! -d /usr/local/go ]; then
        #    wget https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz -O /tmp/go$GO_VERSION.linux-amd64.tar.gz
        #    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go$GO_VERSION.linux-amd64.tar.gz
        #else
        #    echo -e "\nGo is already installed\n"
        #fi
        sudo dnf install -y golang
    fi

    # if [ -z $( grep -Fxq 'export PATH=$HOME/go/bin' $HOME/.bashrc) ]; then
    #     echo "export PATH=$PATH:$HOME/go/bin" >> $HOME/.bashrc
    #     source $HOME/.bashrc
    # fi
}

install_rust() {
    echo -e "$greenplus Installing Rust"
    if [ $(which rustc) ]; then
        echo -e "\nRust is already installed\n"
    else
        #if [ -f $HOME/.cargo/bin/rustup ]; then
        #    echo -e "\nrustc is already installed\n"
        #else
        #    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        #    source "$HOME/.cargo/env"
        #fi
        sudo dnf install -y rust cargo
    fi
}

install_dotnet() {
    echo -e "$greenplus Installing Dotnet"
    if [ $(which dotnet) ]; then
        echo -e "\nDotnet is already installed\n"
    else
        sudo dnf install -y dotnet-sdk-8.0
    fi
}

install_nodejs() {
    echo -e "$greenplus Installing NodeJS"
    if [ $(which node) ]; then
        echo -e "\nNodeJS is already installed\n"
    else
        sudo dnf install -y nodejs
    fi
}

install_ansible() {
    echo -e "$greenplus Installing Ansible"
    if [ $(which ansible) ]; then
        echo -e "\nAnsible is already installed\n"
    else
        python3 -m pip install ansible --user
    fi
}

install_terraform() {
    echo -e "$greenplus Installing Terraform"
    if [ $(which terraform) ]; then
        echo -e "\nTerraform is already installed\n"
    else
        sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
        sudo dnf -y install terraform
    fi
}

install_podman() {
    echo -e "$greenplus Installing Podman"
    if [ $(which podman) ]; then
	    echo -e "\nPodman is already installed\n"
    else
	    sudo dnf install -y podman podman-compose
    fi
}

install_hydra() {
    echo -e "$greenplus Installing Hydra"

    if [ $(which hydra) ]; then
            echo -e "\nHydra is already installed\n"
    else
        distro=$(detect_os)
        if [ $distro == 'fedora' ];then 
            sudo dnf install -y hydra
        else 
            HYDRA_PATH=/usr/local/bin/hydra

            # install dependencies
            sudo dnf install -y openssl-devel pcre-devel ncpfs-devel postgresql-devel libssh-devel subversion-devel libncurses-devel

            if [ ! -d $HOME/src ]; then
                mkdir -pv $HOME/src
            fi;
            
            cd $HOME/src && git clone $HYDRA
            cd $HOME/src/thc-hydra && ./configure && make && sudo make install
        fi

    fi  
}

install_gobuster() {
    echo -e "$greenplus Installing Gobuster"
    if [ -f $HOME/go/bin/gobuster ]; then
        echo -e "\nGobuster is already installed\n"
    else
        go install $GOBUSTER
    fi
}

install_gowitness() {
    echo -e "$greenplus Installing Gowitness"
    if [ -f $HOME/go/bin/gowitness ]; then
        echo -e "\ngowitness is already installed\n"
    else
        go install $GOWITNESS
    fi
}

install_subfinder() {
    echo -e "$greenplus Installing subfinder"
    if [ $(which subfinder) ]; then
        echo -e "\nsubfinder is already installed\n"
    else
        #go install $SUBFINDER
        sudo dnf install -y subfinder
    fi
}

install_assetfinder() {
    echo -e "$greenplus Installing assetfinder"
    if [ $(which assetfinder) ]; then
        echo -e "\nassetfinder is already installed\n"
    else
        #go install $ASSETFINDER
        sudo dnf install -y assetfinder
    fi
}

install_amass() {
    echo -e "$greenplus Installing Amass"
    if [ -f $HOME/go/bin/amass ]; then
        echo -e "\nAmass is already installed\n"
    else
        go install -v $AMASS
    fi
}

install_httprobe() {
    echo -e "$greenplus Installing HTTProbe"
    if [ -f $HOME/go/bin/httprobe ]; then
        echo -e "\nHttprobe is already installed\n"
    else
        go install $HTTPROBE
    fi
}

install_waybackurls() {
    echo -e "$greenplus Installing WaybackURLS"
    if [ -f $HOME/go/bin/waybackurls ]; then
        echo -e "\nWaybackurls is already installed\n"
    else
        go install $WAYBACKURLS
    fi
}


install_wpscan() {
    echo -e "$greenplus Installing WPScan"
    if [ $(which ruby) ]; then
        if [ $(which wpscan) ]; then
            echo -e "\nWPScan is already installed\n"
        else
            gem install wpscan
        fi
    fi
}

install_seclists() {
    echo -e "$greenplus Installing Seclists"
    if [ -d /opt/SecLists/ ]; then
        echo -e "\nSeclists already installed\n"
    else
        cd /opt && sudo git clone --depth 1 $SECLISTS
    fi
}

install_sqlmap() {
    echo -e "$greenplus Installing SQLMap"
    if [ $(which sqlmap) ]; then
        echo -e "\nSQLMap already installed\n"
    else
        python3 -m pip install sqlmap --user
    fi
}

install_wfuzz() {
    echo -e "$greenplus Installing Wfuzz"
    if [ $(which wfuzz) ]; then
        echo -e "\nWfuzz already installed\n"
    else
        python3 -m pip install wfuzz --user
    fi
}

install_nessus() {
    podman pull tenable/nessus:latest-ubuntu
    podman run -d -p 8834:8834 tenable/nessus:latest-ubuntu
}

install_vscode() {
    echo -e "$greenplus Installing VSCode"
    if [ $(which code) ]; then
        echo -e "\nVSCode already installed\n"
    else
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        sudo dnf check-update
        sudo dnf -y install code
    fi
}

full_install() {
    #check_for_root
    distro=$(detect_os)
    if [ $distro != 'fedora' ];then 
        echo -e "$redminus Looks like you're not running Fedora Linux. Please use a supported distribution."
        exit
    fi
    echo -e "$greenplus Setting things up..."

    update_system
    base_packages
    #setup_virtualization
    install_virtualbox
    install_wireshark
    install_brave
    install_podman
    install_go
    install_rust
    install_dotnet
    install_nodejs
    install_ansible
    install_terraform
    install_gobuster
    install_gowitness
    install_amass
    install_subfinder
    install_assetfinder
    install_httprobe
    install_waybackurls
    install_wpscan
    install_seclists
    install_sqlmap
    install_wfuzz
    #install_nessus
    install_hydra
    install_vscode

    echo -e "$greenplus All done! Happy Hacking!!"
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

# Start of main script
#

# Figure out which OS we're running
# distro=$(detect_os)
# if [ $distro == 'fedora' ];then 
#     echo -e "$greenplus YAAAAY Fedora"
# fi
#configure_dnf_repos

