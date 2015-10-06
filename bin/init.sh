#!/usr/bin/env bash
PROJECT_URL="mercadopago.local"

#VIRTUAL HOST
echo "[$0] Creating Virtual Host"
ln -s /vagrant/plugin/htdocs /var/www/magento

cp /vagrant/conf/nginx/site.conf /etc/nginx/sites-available/$PROJECT_URL
sed -i "s|\$PROJECT_URL|${PROJECT_URL}|g" /etc/nginx/sites-available/$PROJECT_URL
ln -s /etc/nginx/sites-available/$PROJECT_URL /etc/nginx/sites-enabled/$PROJECT_URL
service nginx restart
