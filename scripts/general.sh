#!/bin/bash

SECLISTS=https://github.com/danielmiessler/SecLists.git

install_seclists() {
    echo -e "$greenplus Installing Seclists $reset"
    if [ -d /opt/SecLists ]; then
        echo -e "\nSeclists already installed\n"
    else
        cd /opt && sudo git clone --depth 1 $SECLISTS
    fi
}
