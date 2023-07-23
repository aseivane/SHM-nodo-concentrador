#! /bin/bash

echo -e "\nUpdating and installing required packages\n"

apt-get update
wait
apt-get install -y ca-certificates curl gnupg
wait

echo -e "\nAdding Docker keys\n"

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
wait

#  List the available versions:
#  apt-cache madison docker-ce | awk '{ print $3 }'

DOCKER_VERSION=5:24.0.4-1~debian.11~bullseye
COMPOSE_VERSION=2.19.1-1~debian.11~bullseye
echo -e "\nInstalling: \nDOCKER_VERSION=$DOCKER_VERSION\nCOMPOSE_VERSION=$COMPOSE_VERSION\n"

apt-get install -y docker-ce=$DOCKER_VERSION docker-ce-cli=$DOCKER_VERSION containerd.io docker-compose-plugin=$COMPOSE_VERSION
wait

$DOCKER_USER=$USER
echo -e "\nAdding $DOCKER_USER to docker group"
groupadd docker
usermod -aG docker $DOCKER_USER
# newgrp docker
# rm -rf ~/.docker/

echo -e "\nSetting docker as a service\n"

systemctl enable docker.service
systemctl enable containerd.service
