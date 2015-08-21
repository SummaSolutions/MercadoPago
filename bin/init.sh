#!/usr/bin/env bash
PROJECT_DB_NAME="mercadopago"
PROJECT_MAGENTO_ROOT="/vagrant/source/"
PROJECT_URL="mercadopago.local"
PROJECT_ADMIN_USER="admin"
PROJECT_ADMIN_PASSWORD="Summa2015"

#Installing Project
cd /vagrant/
composer install

#Downloading Sample Data
echo "[$0] Downloading Database..."
cd /home/vagrant/
curl -O https://raw.githubusercontent.com/Vinai/compressed-magento-sample-data/1.9.1.0/compressed-no-mp3-magento-sample-data-1.9.1.0.tgz

echo "[$0] Extracting Sample Data..."
tar -zxvf compressed-no-mp3-magento-sample-data-1.9.1.0.tgz

#MYSQL DATABASE
echo "[$0] Creating Database..."
mysql -uroot <<QUERY_INPUT
DROP DATABASE IF EXISTS ${PROJECT_DB_NAME}; CREATE DATABASE ${PROJECT_DB_NAME};
QUERY_INPUT


echo "[$0] Importing Database..."

mysql -uroot <<QUERY_IMPORT
USE ${PROJECT_DB_NAME};SOURCE /home/vagrant/magento-sample-data-1.9.1.0/magento_sample_data_for_1.9.1.0.sql;
QUERY_IMPORT


#MEDIA FOLDER
if [ ! -d ${PROJECT_MAGENTO_ROOT}media ];
then
  echo "[$0] Creating Media Folder..."
  mkdir ${PROJECT_MAGENTO_ROOT}media
fi

echo "[$0] Copying Media Sample Folder..."
cp -R /home/vagrant/magento-sample-data-1.9.1.0/media/* ${PROJECT_MAGENTO_ROOT}media

echo "[$0] Copying Skin Sample Folder..."
cp -R /home/vagrant/magento-sample-data-1.9.1.0/skin/* ${PROJECT_MAGENTO_ROOT}skin

#VAR FOLDER
if [ ! -d ${PROJECT_MAGENTO_ROOT}var ];
then
  echo "[$0] Creating Media Folder..."
  mkdir ${PROJECT_MAGENTO_ROOT}var
fi

echo "[$0] Applying write permissions..."
chmod -R 777 /vagrant/source/{app/etc,media,var}


#VIRTUAL HOST
echo "[$0] Creating Virtual Host"
sudo ln -s /vagrant/source /var/www/magento

sudo cp /vagrant/conf/nginx/mercadopago.conf /etc/nginx/sites-available/$PROJECT_URL
sudo sed -i "s|\$PROJECT_URL|${PROJECT_URL}|g" /etc/nginx/sites-available/$PROJECT_URL
sudo ln -s /etc/nginx/sites-available/$PROJECT_URL /etc/nginx/sites-enabled/$PROJECT_URL
sudo service nginx restart

#MAGENTO INSTALLATION
echo "[$0] Installing Magento..."
rm -f ${PROJECT_MAGENTO_ROOT}app/etc/local.xml
php ${PROJECT_MAGENTO_ROOT}install.php -- \
       --license_agreement_accepted "yes" \
       --locale "en_US" \
       --timezone "America/Los_Angeles" \
       --default_currency "USD" \
       --db_host "localhost" \
       --db_name ${PROJECT_DB_NAME} \
       --skip_url_validation "yes" \
       --db_user "root" \
       --db_pass "" \
       --url "http://${PROJECT_URL}" \
       --secure_base_url "http://${PROJECT_URL}" \
       --use_rewrites "yes" \
       --use_secure "no" \
       --use_secure_admin "no" \
       --session_save "db" \
       --admin_firstname "Admin" \
       --admin_lastname "General" \
       --admin_email "fcapua@summasolutions.net" \
       --admin_username "${PROJECT_ADMIN_USER}" \
       --admin_password "${PROJECT_ADMIN_PASSWORD}"

#PHP INIT SCRIPT
php /vagrant/bin/init.php
