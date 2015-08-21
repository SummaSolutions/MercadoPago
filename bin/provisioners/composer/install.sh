#!/usr/bin/env bash

cd /root
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

