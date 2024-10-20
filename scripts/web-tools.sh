#!/bin/bash

ZAP_RELEASE=ZAP_2.14.0_Linux.tar.gz
ZAP_RELEASE_URL=https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_2.14.0_Linux.tar.gz

install_zap() {
    echo -e "$greenplus Installing ZAProxy $reset"
    if [ -d /opt/ZAP ]; then
        echo -e "\nZAProxy already installed\n"
    else
        cd /tmp && wget $ZAP_RELEASE_URL
        tar xfz $ZAP_RELEASE
        sudo mv $ZAP_RELEASE /opt/ZAP
    fi
}