#!/usr/bin/env bash

#Install Phing
cd /root
curl -o phing.phar http://www.phing.info/get/phing-latest.phar
chmod +x ./phing.phar
cp ./phing.phar /usr/local/bin/