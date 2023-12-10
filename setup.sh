#!/bin/sh

# Verificar si el sistema operativo es Raspbian
if [ -e /etc/os-release ]; then
    source /etc/os-release
    if [ "$ID" != "raspbian" ]; then
        echo "Este script solo es compatible con Raspbian. Cancelando."
        exit 1
    fi
else
    echo -e "\e[31mNo se pudo determinar el sistema operativo. Cancelando.\e[0m"
    exit 1
fi

# Imprimir la versión del sistema operativo
echo "Versión de Raspbian: $VERSION_ID"

# Función para manejar errores
handle_error() {
    echo -e "\e[31mError: $1\e[0m"
    exit 1
}

# Verificar la conexión a Internet
if ping -q -c 1 -W 1 google.com >/dev/null; then
    # Conexión a Internet exitosa
    echo -e "\e[32mConectado a Internet\e[0m"
    
else
    # Sin conexión a Internet
    echo -e "\e[31mSin conexión a Internet\e[0m"
    exit 1
fi

# Actualizar los paquetes
sudo apt-get update || handle_error "No se pudo actualizar la lista de paquetes."
sudo apt-get upgrade -y || handle_error "No se pudo actualizar los paquetes."

echo -e "\nInstalando paquetes:\n"

sudo apt-get install -y git ca-certificates curl gnupg || handle_error "No se pudieron instalar los paquetes."

DIRECTORIO_NODO_CONCENTRADOR=${pwd}
cd ~

git clone https://github.com/aseivane/SHM-API.git || handle_error "No se pudo clonar SHM-API."
wait

git clone https://github.com/lucamazzer/SHM-React-website.git || handle_error "No se pudo clonar SHM-React-website."
wait

cd $DIRECTORIO_NODO_CONCENTRADOR

# Ejecutar el script setup.sh en la carpeta network
cd network
./setup.sh || handle_error "No se pudo ejecutar el script 'setup.sh'."

# Ejecutar scrit instalacion Docker y Docker compose
cd docker
./install.sh || handle_error "No se pudo ejecutar el script 'setup.sh'."