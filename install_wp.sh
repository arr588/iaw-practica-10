#!/bin/bash

#-------------------------------------------------------------------------------
# Configuramos las variables
#-------------------------------------------------------------------------------

# Variables GoAcces
HTTPASSWD_USER=usuario
HTTPASSWD_PASSWD=usuario
HTTPASSWD_DIR=/home/ubuntu

# Variables BD
DBNAME=db_wordpress
DBUSER=db_user
DBPASS=db_password

# Variables WP
URL=100.26.220.3
TITLE="CLI"
USER=usuario
PASS=usuario
EMAIL=test@test.com

# ------------------------------------------------------------------------------
# Instalación de la máquina LAMP
# ------------------------------------------------------------------------------

# Habilitamos el modo de shell para mostrar los comandos que se ejecutan
set -x

# Actualizamos la lista de paquetes
apt update -y

# Instalamos el servidor web Apache
apt install apache2 -y

# Instalamos los módulos necesarios de PHP
apt install php libapache2-mod-php php-mysql -y

# Instalamos el sistema gestor de base de datos
apt install mysql-server -y

# Copiamos la base de datos creada en MySQL
mysql -u root < database.sql

# ------------------------------------------------------------------------------
# Instalación de Wordpress CLI
# ------------------------------------------------------------------------------

cd /var/www/html

# Instalamos CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Eliminamos index.html
rm -rf index.html

# Descargamos el código fuente de WP
wp core download --path=/var/www/html --locale=es_ES --allow-root

# Creamos el archivo de configuración
wp config create --dbname=$DBNAME --dbuser=$DBUSER --dbpass=$DBPASS --allow-root

# Cambiamos los permisos de la carpeta html
chown -R www-data:www-data /var/www/html

# Instalamos Wordpress
wp core install --url=$URL --title=$TITLE --admin_user=$USER --admin_password=$PASS --admin_email=$EMAIL --allow-root

# Instalamos un tema personalizado
sudo wp theme install twentynineteen --activate --allow-root

# Instalamos los plugins seleccionados
wp plugin install bbpress gdpr --activate --allow-root

# Reiniciamos apache2
systemctl restart apache2