#!/bin/bash

install_ansible() {
    echo -e "$greenplus Installing Ansible $reset"
    if [ $(which ansible) ]; then
        echo -e "\nAnsible is already installed\n"
    else
        python3 -m pip install --user ansible ansible-navigator ansible-builder
    fi
}

install_terraform() {
    echo -e "$greenplus Installing Terraform $reset"
    if [ $(which terraform) ]; then
        echo -e "\nTerraform is already installed\n"
    else
        sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
        sudo dnf -y install terraform
    fi
}

install_container_tools() {
    echo -e "$greenplus Installing Podman $reset"
    if [ $(which podman) ]; then
	    echo -e "\nPodman is already installed\n"
    else
	    sudo dnf install -y podman podman-compose podman-docker skopeo buildah
    fi

    echo -e "$greenplus Installing Docker $reset"
    if [ $(which docker) ]; then
        echo -e "\nDocker is already installed\n"
    else
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
        sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    fi
}