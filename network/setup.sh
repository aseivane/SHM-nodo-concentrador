#! /bin/sh
cp iptables.up.conf /etc/network/iptables.up.conf
cp -r if-pre-up.d /etc/network/
cp -r if-up.d /etc/network/