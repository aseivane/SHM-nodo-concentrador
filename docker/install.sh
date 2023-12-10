#! /bin/env

docker_keys(){
    echo -e "\nAdding Docker keys\n"

    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    wait
}

# Verificar si Docker está instalado
if command -v docker &>/dev/null; then
    echo "Docker ya está instalado. Verificando versión..."
    installed_docker_version=$(docker --version | awk '{print $3}' | cut -d ',' -f1)
    echo "Versión de Docker instalada: $installed_docker_version"
else
    # Instalar docker keys
    docker_keys

    # Menú interactivo para seleccionar la versión de Docker

    options=()
    while IFS= read -r version; do
        options+=( "$version" "" )
    done < <(apt list -a -q docker-ce | grep -oP '\b\d+:\d+\.\d+\.\d+~[^\s]+\b')

    selected_version=$(whiptail --title "Selecciona la versión de Docker" --menu "Elige una versión:" 18 70 10 "${options[@]}" 3>&2 2>&1 1>&3) || handle_error "Cancelado."

    # Instalar Docker con la versión seleccionada
    sudo apt-get install -y "docker-ce=$selected_version"

    # Agregar user al grupo de docker
    echo -e "\Agregando $DOCKER_USER al grupo docker"
    DOCKER_USER=user
    sudo usermod -aG docker $DOCKER_USER || handle_error "No se pudo agregar el usuario "$DOCKER_USER" al grupo 'docker'."

    echo -e "\Configurando docker como servicio\n"
    systemctl enable docker.service || handle_error "No se pudo habilitar Docker como servicio."
    systemctl enable containerd.service || handle_error "No se pudo habilitar containerd como servicio."
fi

# Verificar si Docker Compose está instalado
if command -v docker compose &>/dev/null; then
    echo "Docker Compose ya está instalado."
    installed_compose_version=$(docker compose --version | awk '{print $3}')
    echo "Versión de Docker Compose instalada: $installed_compose_version"
else
    # Instalar Docker Compose
    # Menú interactivo para seleccionar la versión de Docker Compose
    options=()
    while IFS= read -r version; do
        options+=( "$version" "" )
    done < <(apt list -a -q docker-compose-plugin | grep -oP '\b\d+\.\d+\.\d+~[^\s]+\b')

    selected_version=$(whiptail --title "Selecciona la versión de Docker Compose" --menu "Elige una versión:" 18 70 10 "${options[@]}" 3>&2 2>&1 1>&3) || handle_error "Cancelado."

    # Instalar Docker Compose con la versión seleccionada
    sudo apt-get install -y "docker-compose-plugin=$selected_version"

fi
#  List the available versions:
#  apt-cache madison docker-ce | awk '{ print $3 }'

#DOCKER_VERSION=5:24.0.4-1~debian.11~bullseye
#COMPOSE_VERSION=2.19.1-1~debian.11~bullseye
#echo -e "\nInstalling: \nDOCKER_VERSION=$DOCKER_VERSION\nCOMPOSE_VERSION=$COMPOSE_VERSION\n"

#apt-get install -y docker-ce=$DOCKER_VERSION docker-ce-cli=$DOCKER_VERSION containerd.io docker-compose-plugin=$COMPOSE_VERSION
#wait





