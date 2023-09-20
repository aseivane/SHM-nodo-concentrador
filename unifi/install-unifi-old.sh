#! /bin/bash

# downloaded from https://community.ui.com/questions/Step-By-Step-Tutorial-Guide-Raspberry-Pi-with-UniFi-Controller-and-Pi-hole-from-scratch-headless/e8a24143-bfb8-4a61-973d-0b55320101dc

Colour='\033[1;31m'
less='\033[0m'
requiredver='7.3.76'

echo -e "${Colour}By using this script, you'll update the system, install the stable UniFi controller of your choice\nUse CTRL+C to cancel the script\n\n${less}"
read -p "Please enter a STABLE version (e.g: 7.2.95) or press enter for version 7.5.176: " version

if [[ -z "$version" ]]; then
	version='7.5.176-1136930355'
fi

echo -e "${Colour}\n\nThe system will now upgrade all the software and firmware, as well as clean up old/unused packages.\n\n${less}"
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt-get autoclean -y

echo -e "${Colour}\n\nThe UniFi controller with version $version is downloading now.\n\n${less}"
wget https://dl.ui.com/unifi/$version/unifi_sysvinit_all.deb -O unifi_$version\_sysvinit_all.deb

echo -e "${Colour}\n\nChecking if Java 11 is required for this version...\n\n${less}"
if [ "$(printf '%s\n' "$requiredver" "$version" | sort -V | head -n1)" = "$requiredver" ]; 
 then 
    echo -e "${Colour}\n\nJava 11 is required. Checking if Java 11 is installed...\n\n${less}"
 	if [ $(dpkg-query -W -f='${Status}' openjdk-11-jre-headless 2>/dev/null | grep -c "ok installed") -eq 0 ];
	then
		echo -e "${Colour}\n\nJava 11 wasn't found, installing now...\n\n${less}"
		sudo apt install openjdk-11-jre-headless -y
	fi	
 else
     echo -e "${Colour}\n\nJava 17 is required for the chosen version. Installing now.\n\n${less}"
     sudo apt install openjdk-11-jre-headless -y
 fi
 
echo -e "${Colour}\n\nMongoDB will now be installed as it's a dependency of UniFi.\n\n${less}"
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

echo -e "${Colour}\n\nThe UniFi controller will be installed now.\n\n${less}"
sudo dpkg -i unifi_$version\_sysvinit_all.deb; sudo apt install -f -y

echo -e "${Colour}\n\nTo finish the installation, a reboot is required. Starting a reboot in 3 seconds.\n\n${less}"
sleep 3
echo -e "${Colour}\nRestarting the Raspberry Pi now.\n${less}"
sudo reboot now