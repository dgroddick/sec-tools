#!/bin/bash

install_nessus() {
    podman pull tenable/nessus:latest-ubuntu
    podman run -d -p 8834:8834 tenable/nessus:latest-ubuntu
}