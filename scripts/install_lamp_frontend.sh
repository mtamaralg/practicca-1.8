#!/bin/bash
# -e: Finaliza el script cuando hay error
# -x: Muestra el comando por pantalla
set -ex

# Actualizamos repositorios y paquetes
apt update
apt upgrade -y

# Instalamos apache
apt install apache2 -y

# Instalamos php y módulos necesarios
apt install php libapache2-mod-php php-mysql php-curl php-gd php-xml php-mbstring -y

# Instalamos el cliente de MySQL (Requisito apartado 1.7)
apt install mysql-client -y

# Copiamos el archivo de configuracion de apache
cp ../conf/000-default.conf /etc/apache2/sites-available

# Reiniciamos apache
systemctl restart apache2