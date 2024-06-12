#!/bin/bash

# Update package lists and upgrade installed packages
sudo apt update
sudo apt upgrade -y

# Install necessary packages
sudo apt install -y ca-certificates apt-transport-https lsb-release gnupg curl nano unzip
