<?php
$localFile = '/vagrant/source/app/etc/local.xml';
$localContent = file_get_contents($localFile);

//REDIS CONFIGURATION
$redisFile = '/vagrant/conf/magento/redis.xml';
$redisConf = file_get_contents($redisFile);

$localContent = str_replace('</global>', $redisConf."\n</global>", $localContent);

file_put_contents($localFile, $localContent);