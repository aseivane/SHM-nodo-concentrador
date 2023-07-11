#! /bin/bash

echo -e "\nUpdating and installing required packages\n"

apt-get update
apt-get install ca-certificates curl gnupg
wait

echo -e "\nAdding Docker keys\n"

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/raspbian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

#  List the available versions:
#  apt-cache madison docker-ce | awk '{ print $3 }'

echo -e "\nInstalling: \nDOCKER_VERSION=5:24.0.4-1~raspbian.11~bullseye\nCOMPOSE_VERSION=2.19.1-1~raspbian.11~bullseye\n"

DOCKER_VERSION=5:24.0.4-1~raspbian.11~bullseye
COMPOSE_VERSION=2.19.1-1~raspbian.11~bullseye
apt-get install -y docker-ce=$DOCKER_VERSION docker-ce-cli=$DOCKER_VERSION containerd.io docker-compose-plugin=$COMPOSE_VERSION

# $DOCKER_USER=pi
# echo -e "\nAdding $DOCKER_USER to docker group"
# groupadd docker
# usermod -aG docker $DOCKER_USER
# newgrp docker
# rm -rf ~/.docker/

echo -e "\nSetting docker as a service\n"

systemctl enable docker.service
systemctl enable containerd.service
