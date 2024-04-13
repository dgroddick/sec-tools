#!/bin/bash
#
# Tools for Reverse Engineering and Malware Analysis

# Ghidra
# TrID

GHIDRA_RELEASE=ghidra_11.0.3_PUBLIC_20240410.zip
GHIDRA_RELEASE_URL=https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.0.3_build/ghidra_11.0.3_PUBLIC_20240410.zip

install_ghidra() {
    echo -e "$greenplus Installing Ghidra $reset"
    if [ -d /opt/ghidra ]; then
        echo -e "\nGhidra already installed\n"
    else
        cd /tmp && wget $GHIDRA_RELEASE_URL
        unzip $GHIDRA_RELEASE
        mv $GHIDRA_RELEASE /opt/ghidra
    fi
}