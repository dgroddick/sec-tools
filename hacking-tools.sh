#!/bin/bash

CORE_HACK_TOOLS=("john")
HYDRA=https://github.com/vanhauser-thc/thc-hydra.git


base_hacking_packages() {
    echo -e "$greenplus Installing required required packages $reset"
    dnf install -y "${CORE_HACK_TOOLS[@]}"
}

install_hydra() {
    echo -e "$greenplus Installing Hydra $reset"

    if [ $(which hydra) ]; then
        echo -e "\nHydra is already installed\n"
    else
        dnf install -y hydra
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

install_sqlmap() {
    echo -e "$greenplus Installing SQLMap $reset"
    if [ $(which sqlmap) ]; then
        echo -e "\nSQLMap already installed\n"
    else
        python3 -m pip install sqlmap --user
    fi
}