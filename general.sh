#!/bin/bash

SECLISTS=https://github.com/danielmiessler/SecLists.git

install_seclists() {
    echo -e "$greenplus Installing Seclists $reset"
    if [ -d /opt/SecLists ]; then
        echo -e "\nSeclists already installed\n"
    else
        cd /opt && git clone --depth 1 $SECLISTS
    fi
}

install_wireshark() {
    echo -e "$greenplus Installing Wireshark $reset"
    if [ $(which wireshark) ]; then
        echo -e "\nWireshark is already installed\n"
    else
        dnf install -y wireshark
    fi
}