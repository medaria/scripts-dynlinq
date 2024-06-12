#!/bin/bash

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
