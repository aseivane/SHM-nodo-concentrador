#! /bin/bash

sudo apt-get update
wait 

sudo apt-get -y upgrade
wait

sudo install git

./download-repos.sh