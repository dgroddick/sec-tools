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