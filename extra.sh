#!/bin/bash

GOBUSTER=github.com/OJ/gobuster/v3@latest
GOWITNESS=github.com/sensepost/gowitness@latest
SUBFINDER=github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
ASSETFINDER=github.com/tomnomnom/assetfinder
WAYBACKURLS=github.com/tomnomnom/waybackurls@latest
SUBLIST3R=https://github.com/aboul3la/Sublist3r
THEHARVESTER=https://github.com/laramies/theHarvester.git
SHERLOCK=https://github.com/sherlock-project/sherlock.git

# HTTPSCREENSHOT=https://github.com/breenmachine/httpscreenshot
# MASSCAN=https://github.com/robertdavidgraham/masscan
# SOCIALSCAN=https://github.com/iojw/socialscan
# BLACKBIRD=https://github.com/p1ngul1n0/BlackBird
# PHOTON=https://github.com/s0md3v/Photon.git


install_gowitness() {
    echo -e "$greenplus Installing Gowitness $reset"
    if [ $(which gowitness) ]; then
        echo -e "\ngowitness is already installed\n"
    else
        go install $GOWITNESS
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
            gem update && gem install wpscan --no-document
        fi
    fi
}

install_sublist3r() {
    echo -e "$greenplus Installing Sublist3r $reset"
    if [ -d $HOME/tools/Sublist3r ]; then
        echo -e "\nSublist3r already installed\n"
    else
        cd $HOME/tools/ && git clone --depth 1 $SUBLIST3R
    fi
}

install_theharvester() {
    echo -e "$greenplus Installing TheHarvester $reset"
    if [ -d $HOME/tools/theHarvester ]; then
        echo -e "\ntheHarvester already installed\n"
    else
        cd $HOME/tools/ && git clone --depth 1 $THEHARVESTER
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