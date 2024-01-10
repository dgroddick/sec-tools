#!/bin/bash
# Tools for recon

install_gobuster() {
    echo -e "$greenplus Installing Gobuster $reset"
    if [ $(which gobuster) ]; then
        echo -e "\nGobuster is already installed\n"
    else
        go install $GOBUSTER
    fi
}

install_gowitness() {
    echo -e "$greenplus Installing Gowitness $reset"
    if [ $(which gowitness) ]; then
        echo -e "\ngowitness is already installed\n"
    else
        go install $GOWITNESS
    fi
}

install_subfinder() {
    echo -e "$greenplus Installing subfinder $reset"
    if [ $(which subfinder) ]; then
        echo -e "\nsubfinder is already installed\n"
    else
        #go install $SUBFINDER
        sudo dnf install -y subfinder
    fi
}

install_assetfinder() {
    echo -e "$greenplus Installing assetfinder $reset"
    if [ $(which assetfinder) ]; then
        echo -e "\nassetfinder is already installed\n"
    else
        #go install $ASSETFINDER
        sudo dnf install -y assetfinder
    fi
}

install_amass() {
    echo -e "$greenplus Installing Amass $reset"
    if [ $(which amass) ]; then
        echo -e "\nAmass is already installed\n"
    else
        go install -v $AMASS
    fi
}

install_httprobe() {
    echo -e "$greenplus Installing HTTProbe $reset"
    if [ $(which httprobe) ]; then
        echo -e "\nHttprobe is already installed\n"
    else
        go install $HTTPROBE
    fi
}

install_waybackurls() {
    echo -e "$greenplus Installing Waybackurls $reset"
    if [ $(which waybackurls) ]; then
        echo -e "\nWaybackurls is already installed\n"
    else
        go install $WAYBACKURLS
    fi
}