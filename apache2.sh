#!/bin/bash

# Update package lists and upgrade installed packages
sudo apt update
sudo apt upgrade -y

# Install necessary packages
sudo apt install -y ca-certificates apt-transport-https lsb-release gnupg curl nano unzip

# Add PHP repository and install PHP 8
curl -fsSL https://packages.sury.org/php/apt.gpg | sudo tee /usr/share/keyrings/php-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/php-archive-keyring.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
sudo apt update

# Install Apache2
sudo apt install -y apache2

# Install PHP 8 and necessary modules
sudo apt install -y php8.2 php8.2-cli php8.2-common php8.2-curl php8.2-gd php8.2-intl php8.2-mbstring php8.2-mysql php8.2-opcache php8.2-readline php8.2-xml php8.2-xsl php8.2-zip php8.2-bz2 libapache2-mod-php8.2

# Install MariaDB
sudo apt install -y mariadb-server mariadb-client

# Secure MariaDB installation
sudo mysql_secure_installation <<EOF

n
Y
Y
Y
Y
EOF

# Download and install phpMyAdmin
cd /usr/share
sudo wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -O phpmyadmin.zip
sudo unzip phpmyadmin.zip
sudo rm phpmyadmin.zip
sudo mv phpMyAdmin-*-all-languages phpmyadmin
sudo chmod -R 0755 phpmyadmin

# Create Apache2 configuration file for phpMyAdmin
sudo bash -c 'cat <<EOF > /etc/apache2/conf-available/phpmyadmin.conf
# phpMyAdmin Apache configuration

Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php
</Directory>

# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/templates>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Require all denied
</Directory>
EOF'

# Enable phpMyAdmin configuration and reload Apache
sudo a2enconf phpmyadmin
sudo systemctl reload apache2

# Create phpMyAdmin temporary directory and set permissions
sudo mkdir /usr/share/phpmyadmin/tmp/
sudo chown -R www-data:www-data /usr/share/phpmyadmin/tmp/

echo "Installation completed. Access phpMyAdmin at http://your_server_ip/phpmyadmin"
