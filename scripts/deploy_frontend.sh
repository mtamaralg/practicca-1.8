#!/bin/bash
set -ex

# Importamos las variables de entorno
source .env

# -------------------------------------------------------------
# 1. CONFIGURACIÓN DE APACHE (CRÍTICO PARA EL ERROR 404)
# -------------------------------------------------------------
a2enmod rewrite

sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
systemctl restart apache2

# -------------------------------------------------------------
# 2. INSTALACIÓN DE WORDPRESS
# -------------------------------------------------------------
rm -f /tmp/wp-cli.phar
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp
chmod +x /tmp/wp-cli.phar
mv /tmp/wp-cli.phar /usr/local/bin/wp

rm -rf /var/www/html/*

wp core download --locale=es_ES --path=/var/www/html --allow-root

wp config create \
  --dbname=$WORDPRESS_DB_NAME \
  --dbuser=$WORDPRESS_DB_USER \
  --dbpass=$WORDPRESS_DB_PASSWORD \
  --dbhost=$BACKEND_PRIVATE_IP \
  --path=/var/www/html \
  --allow-root

wp core install \
  --url=$CERTBOT_DOMAIN \
  --title="$WORDPRESS_TITLE" \
  --admin_user=$WORDPRESS_ADMIN_USER \
  --admin_password=$WORDPRESS_ADMIN_PASSWORD \
  --admin_email=$WORDPRESS_ADMIN_EMAIL \
  --path=/var/www/html \
  --allow-root  

# -------------------------------------------------------------
# 3. CONFIGURACIÓN DE URLS Y SEGURIDAD
# -------------------------------------------------------------
wp rewrite structure '/%postname%/' --path=/var/www/html --allow-root
wp plugin install wps-hide-login --activate --path=/var/www/html --allow-root
wp option update whl_page "$URL_HIDE_LOGIN" --path=/var/www/html --allow-root

# Copiamos el .htaccess personalizado desde tu carpeta local a la web
cp ../htaccess/.htaccess /var/www/html/.htaccess

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html