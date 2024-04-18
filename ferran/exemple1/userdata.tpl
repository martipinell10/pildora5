#!/bin/bash
# WORDPRESS INSTALLER

# Variables que s'utilitzen recurrentment per les plantilles de terraform.
db_username=${db_username}
db_user_password=${db_user_password}
db_name=${db_name}
db_endpoint=${db_endpoint}
efs_DNS=${efs_DNS}

# Instl·lació LAMP.
apt update
apt install -y apache2 php libapache2-mod-php php-mysql mysql-server

# Canviar permissos i propietari del directori "/var/www".
usermod -a -G apache ubuntu
chown -R ubuntu:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
systemctl restart apache2

# Instal·lació de git i binutils.
apt install -y git binutils
sleep 40

# Clonació del repositori amazon-efs-utils de GitHub.
git clone https://github.com/aws/efs-utils

# Creació i instal·lació del paquet amazon-efs-utils.
cd efs-utils/
./build-deb.sh
apt-get -y install ./build/amazon-efs-utils*deb
sleep 40

# Montar el EFS en el directori de wordpress.
cd /var/www/html
mkdir wordpress/
mount -t efs -o tls ${efs_DNS}:/ /var/www/html/wordpress/

# Descarregar i extreure el fitxer comprimit de wordpress.
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
rm latest.tar.gz

# Creació fitxer de configuració wordpress i actualització dels valors de BBDD.
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sed -i "s/database_name_here/${db_name}/g" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/${db_username}/g" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/${db_user_password}/g" /var/www/html/wordpress/wp-config.php
sed -i "s/localhost/${db_endpoint}/g" /var/www/html/wordpress/wp-config.php
