#! /bin/env
git clone --depth 1 https://github.com/pi-hole/pi-hole.git ~/Pi-hole
cd ~/Pi-hole/automated\ install/
sudo bash basic-install.sh
wait

sudo apt-get -y install php7.4-fpm php7.4-cgi php7.4-xml php7.4-sqlite3 php7.4-intl apache2-utils

systemctl enable php7.4-fpm

# Change ownership of the html directory to nginx user

sudo chown -R www-data:www-data /var/www/html

# Make sure the html directory is writable
sudo chmod -R 755 /var/www/html

# Grant the admin panel access to the gravity database
sudo usermod -aG pihole www-data

#Start php7.3-fpm daemon
sudo systemctl start php7.4-fpm