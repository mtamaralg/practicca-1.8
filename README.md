# Práctica: Despliegue de WordPress en Arquitectura de Dos Niveles (Two-Tier)

## 📖 Descripción General
Este repositorio contiene los scripts de infraestructura como código (IaC) para automatizar el despliegue de un entorno WordPress profesional. 

A diferencia de las arquitecturas monolíticas, este proyecto utiliza una **arquitectura de dos niveles (Frontend y Backend)** separando el servidor web del servidor de base de datos en dos máquinas distintas. Además, automatiza la instalación de WordPress mediante **WP-CLI**, configura reglas de seguridad (URLs ocultas) y protege el tráfico del usuario final con un certificado SSL/TLS de **Let's Encrypt**.

## 📂 Estructura del Repositorio

* **`conf/`**: Configuración del servidor web.
  * `000-default.conf`: VirtualHost base de Apache con permisos para leer archivos `.htaccess`.
* **`htaccess/`**: Reglas de servidor.
  * `.htaccess`: Fichero con las directivas de reescritura para los enlaces permanentes amigables de WordPress.
* **`php/`**: Archivos de validación.
  * `index.php`: Script básico para comprobar el funcionamiento del procesador PHP.
* **`scripts/`**: Ejecutables de automatización separados por nivel (Tier).
  * `.env`: Centraliza todas las contraseñas, nombres de usuario, el dominio público y, críticamente, las **IPs privadas** de ambas máquinas para permitir la comunicación interna segura.
  * `install_lamp_backend.sh`: Instala MySQL Server y configura el archivo `mysqld.cnf` para aceptar peticiones desde la IP del Frontend.
  * `deploy_backend.sh`: Crea la base de datos y un usuario estricto que solo tiene permisos si se conecta desde el servidor web.
  * `install_lamp_frontend.sh`: Instala Apache, PHP y el cliente de MySQL para comprobar la conexión.
  * `deploy_frontend.sh`: Descarga WordPress usando WP-CLI, lo vincula a la IP remota del Backend, inyecta plugins de seguridad y configura los directorios.
  * `setup_letencrypt_certificate.sh`: Habilita la conexión HTTPS solicitando un certificado válido a Certbot.

## ⚙️ Configuración Previa

Es **estrictamente necesario** rellenar correctamente el archivo `scripts/.env` antes de ejecutar nada. Debes conocer las direcciones IP privadas de las dos máquinas (proporcionadas por tu proveedor de nube, ej. AWS) y asegurarte de que el dominio apunta a la IP pública del **Frontend**.

Ejemplo de variables críticas necesarias en el `.env`:
```env
BACKEND_PRIVATE_IP="172.31.X.X"
FRONTEND_PRIVATE_IP="172.31.Y.Y"
WORDPRESS_DB_NAME="wordpress_db"
WORDPRESS_DB_USER="wp_user"
CERTBOT_DOMAIN="tu-dominio.ddns.net"
