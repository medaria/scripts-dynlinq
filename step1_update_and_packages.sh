#!/bin/bash

# Update package lists and upgrade installed packages
sudo apt update
sudo apt upgrade -y

# Install necessary packages
sudo apt install -y ca-certificates apt-transport-https lsb-release gnupg curl nano unzip

# Add PHP repository
curl -fsSL https://packages.sury.org/php/apt.gpg | sudo tee /usr/share/keyrings/php-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/php-archive-keyring.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt update

# Install PHP 8 and necessary modules
sudo apt install -y php8.2 php8.2-cli php8.2-common php8.2-curl php8.2-gd php8.2-intl php8.2-mbstring php8.2-mysql php8.2-opcache php8.2-readline php8.2-xml php8.2-xsl php8.2-zip php8.2-bz2 libapache2-mod-php8.2
