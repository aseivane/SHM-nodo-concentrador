#! /bin/sh
sudo cp iptables.up.conf /etc/network/iptables.up.conf
sudo cp -r if-pre-up.d /etc/network/
sudo cp -r if-up.d /etc/network/
sudo cp dhcpcd.conf /etc/dhcpcd.conf