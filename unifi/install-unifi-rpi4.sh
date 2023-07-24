#! /bin/sh
# https://pimylifeup.com/rasberry-pi-unifi/

sudo apt update
wait
sudo apt upgrade
wait


sudo apt install -y rng-tools
sudo mv rng-tools-debian /etc/default/rng-tools-debian
sudo systemctl restart rng-tools
wait

wget http://ports.ubuntu.com/pool/main/o/openssl/libssl1.0.0_1.0.2g-1ubuntu4_arm64.deb -O libssl1.0.deb
sudo dpkg -i libssl1.0.deb
wait

wget https://repo.mongodb.org/apt/ubuntu/dists/xenial/mongodb-org/3.6/multiverse/binary-arm64/mongodb-org-server_3.6.22_arm64.deb -O mongodb.deb
sudo dpkg -i mongodb.deb
wait
sudo systemctl enable mongod
sudo systemctl start mongod

echo 'deb [arch=armhf signed-by=/usr/share/keyrings/ubiquiti-archive-keyring.gpg] https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list
curl https://dl.ui.com/unifi/unifi-repo.gpg | sudo tee /usr/share/keyrings/ubiquiti-archive-keyring.gpg >/dev/null
sudo apt update
wait

sudo apt install openjdk-11-jre-headless unifi
wait