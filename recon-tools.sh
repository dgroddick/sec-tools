#!/bin/bash

SCAN_TOOLS=("nmap" "netcat" "nikto" "ffuf")

GOBUSTER=github.com/OJ/gobuster/v3@latest
GOWITNESS=github.com/sensepost/gowitness@latest
SUBFINDER=github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
ASSETFINDER=github.com/tomnomnom/assetfinder
AMASS=github.com/owasp-amass/amass/v4/...@master
HTTPROBE=github.com/tomnomnom/httprobe@latest 
WAYBACKURLS=github.com/tomnomnom/waybackurls@latest
SUBLIST3R=https://github.com/aboul3la/Sublist3r
THEHARVESTER=https://github.com/laramies/theHarvester.git
SHERLOCK=https://github.com/sherlock-project/sherlock.git

# HTTPSCREENSHOT=https://github.com/breenmachine/httpscreenshot
# MASSCAN=https://github.com/robertdavidgraham/masscan
# SOCIALSCAN=https://github.com/iojw/socialscan
# BLACKBIRD=https://github.com/p1ngul1n0/BlackBird
# PHOTON=https://github.com/s0md3v/Photon.git


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
        dnf install -y subfinder
    fi
}

install_assetfinder() {
    echo -e "$greenplus Installing assetfinder $reset"
    if [ $(which assetfinder) ]; then
        echo -e "\nassetfinder is already installed\n"
    else
        dnf install -y assetfinder
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

install_sublist3r() {
    echo -e "$greenplus Installing Sublist3r $reset"
    if [ -d /opt/Sublist3r ]; then
        echo -e "\nSublist3r already installed\n"
    else
        cd /opt && git clone --depth 1 $SUBLIST3R
    fi
}

install_theharvester() {
    echo -e "$greenplus Installing TheHarvester $reset"
    if [ -d /opt/theHarvester ]; then
        echo -e "\ntheHarvester already installed\n"
    else
        cd /opt && git clone --depth 1 $THEHARVESTER
    fi
}

install_sherlock() {
    echo -e "$greenplus Installing Sherlock $reset"
    if [ -d /opt/sherlock ]; then
        echo -e "\nSherlock already installed\n"
    else
        cd /opt && git clone --depth 1 $SHERLOCK
    fi
}