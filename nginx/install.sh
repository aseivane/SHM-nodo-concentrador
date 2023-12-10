#! /bin/env

# Instalar nginx
sudo apt-get install -y nginx || handle_error "No se pudo instalar NGINX."

# Mover la configuracion de Nginx
sudo mv nginx.conf /etc/nginx/ || handle_error "No se pudo compiar la configuracion de NGINX."

# Copiar las configuraciones
sudo cp -r sites-available /etc/nginx/ || handle_error "No se pudieron copiar los servers virtuales."

# Crear los link simbolicos
sudo ln -s /etc/nginx/sites-available/shm-fiuba /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/wifi-shm-fiuba /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/dns-shm-fiuba /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Reiniciar servicio de NGINX
sudo systemctl restart nginx || handle_error "No se pudo reiniciar el servicio NGINX."
