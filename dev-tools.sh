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