#!/bin/bash

install_go() {
    echo -e "$greenplus Installing Go $reset"
    if [ $(which go) ]; then
        echo -e "\nGo is already installed\n"
    else
        sudo dnf install -y golang
    fi
}

install_rust() {
    echo -e "$greenplus Installing Rust $reset"
    if [ $(which rustc) ]; then
        echo -e "\nRust is already installed\n"
    else
        sudo dnf install -y rust cargo
    fi
}

install_dotnet() {
    echo -e "$greenplus Installing Dotnet $reset"
    if [ $(which dotnet) ]; then
        echo -e "\nDotnet is already installed\n"
    else
        sudo dnf install -y dotnet-sdk-8.0
    fi
}

install_nodejs() {
    echo -e "$greenplus Installing NodeJS $reset"
    if [ $(which node) ]; then
        echo -e "\nNodeJS is already installed\n"
    else
        sudo dnf install -y nodejs
    fi
}

install_ansible() {
    echo -e "$greenplus Installing Ansible $reset"
    if [ $(which ansible) ]; then
        echo -e "\nAnsible is already installed\n"
    else
        python3 -m pip install ansible --user
    fi
}

install_terraform() {
    echo -e "$greenplus Installing Terraform $reset"
    if [ $(which terraform) ]; then
        echo -e "\nTerraform is already installed\n"
    else
        sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
        sudo dnf -y install terraform
    fi
}

install_container_tools() {
    echo -e "$greenplus Installing Podman $reset"
    if [ $(which podman) ]; then
	    echo -e "\nPodman is already installed\n"
    else
	    sudo dnf install -y podman podman-compose
    fi

    echo -e "$greenplus Installing Docker $reset"
    if [ $(which docker) ]; then
        echo -e "\nDocker is already installed\n"
    else
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
        sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    fi
}

install_hydra() {
    echo -e "$greenplus Installing Hydra $reset"

    if [ $(which hydra) ]; then
            echo -e "\nHydra is already installed\n"
    else
        sudo dnf install -y hydra
        #distro=$(detect_os)
        # if [ $distro == 'fedora' ];then 
        #     sudo dnf install -y hydra
        # elif [ $distro == 'rhel' ]; then 
        #     #HYDRA_PATH=/usr/local/bin/hydra

        #     # install dependencies
        #     sudo dnf install -y openssl-devel pcre-devel ncpfs-devel postgresql-devel libssh-devel subversion-devel libncurses-devel

        #     if [ ! -d $HOME/src ]; then
        #         mkdir -pv $HOME/src
        #     fi;
            
        #     cd $HOME/src && git clone $HYDRA
        #     cd $HOME/src/thc-hydra && ./configure && make && sudo make install
        # fi
    fi  
}

install_wpscan() {
    echo -e "$greenplus Installing WPScan $reset"
    if [ $(which ruby) ]; then
        if [ $(which wpscan) ]; then
            echo -e "\nWPScan is already installed\n"
        else
            gem install wpscan
        fi
    fi
}

install_seclists() {
    echo -e "$greenplus Installing Seclists $reset"
    if [ -d $HOME/SecLists ]; then
        echo -e "\nSeclists already installed\n"
    else
        cd $HOME && git clone --depth 1 $SECLISTS
    fi
}

install_sqlmap() {
    echo -e "$greenplus Installing SQLMap $reset"
    if [ $(which sqlmap) ]; then
        echo -e "\nSQLMap already installed\n"
    else
        python3 -m pip install sqlmap --user
    fi
}

install_wfuzz() {
    echo -e "$greenplus Installing Wfuzz $reset"
    if [ $(which wfuzz) ]; then
        echo -e "\nWfuzz already installed\n"
    else
        python3 -m pip install wfuzz --user
    fi
}

install_vscode() {
    echo -e "$greenplus Installing VSCode $reset"
    if [ $(which code) ]; then
        echo -e "\nVSCode already installed\n"
    else
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        sudo dnf check-update
        sudo dnf -y install code
    fi
}

install_virtualbox() {
    echo -e "$greenplus Installing VirtualBox $reset"
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
    echo -e "$greenplus Installing Wireshark $reset"
    if [ $(which wireshark) ]; then
        echo -e "\nWireshark is already installed\n"
    else
        sudo dnf install -y wireshark
    fi
}

install_brave() {
    echo -e "$greenplus Installing Brave Browser $reset"
    if [ $(which brave-browser) ]; then
        echo -e "\nBrave Browser is already installed\n"
    else
        sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
        sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
        sudo dnf install -y brave-browser
    fi
}
