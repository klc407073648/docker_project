#!/bin/bash
source ./common.sh

#全局变量
config_file='.env'

function modifyEnvVar() {
  logDebug "modifyEnvVar begin"

  WEBSERVER_HOST_IP=`cat $config_file |grep "WEBSERVER_HOST_IP=" |cut -f2 -d'='`
  WEBSERVER_HOST_PORT=`cat $config_file |grep "WEBSERVER_HOST_PORT=" |cut -f2 -d'='`
  NGINX_HOST_PORT=`cat $config_file |grep "NGINX_HOST_PORT=" |cut -f2 -d'='`

  MYSQL_HOST_IP=`cat $config_file |grep "MYSQL_HOST_IP=" |cut -f2 -d'='`
  MYSQL_CONTAINER_PORT=`cat $config_file |grep "MYSQL_CONTAINER_PORT=" |cut -f2 -d'='`
  MYSQL_PASSWORD=`cat $config_file |grep "MYSQL_PASSWORD=" |cut -f2 -d'='`

  logInfo "WEBSERVER_HOST_IP:[${WEBSERVER_HOST_IP}]"
  logInfo "WEBSERVER_HOST_PORT:[${WEBSERVER_HOST_PORT}]"
  logInfo "NGINX_HOST_PORT:[${NGINX_HOST_PORT}]"
  
  logInfo "MYSQL_HOST_IP:[${MYSQL_HOST_IP}]"
  logInfo "MYSQL_CONTAINER_PORT:[${MYSQL_CONTAINER_PORT}]"
  logInfo "MYSQL_PASSWORD:[${MYSQL_PASSWORD}]"

  sed -i "s/\$WEBSERVER_HOST_IP/$WEBSERVER_HOST_IP/g"         ./environment/nginx/conf.d/default.conf
  sed -i "s/\$WEBSERVER_HOST_PORT/$WEBSERVER_HOST_PORT/g"     ./environment/nginx/conf.d/default.conf
  sed -i "s/\$NGINX_HOST_PORT/$NGINX_HOST_PORT/g"             ./environment/nginx/conf.d/default.conf

  sed -i "s/\$MYSQL_HOST_IP/$MYSQL_HOST_IP/g"                 ./environment/webserver/mysql.yml
  sed -i "s/\$MYSQL_CONTAINER_PORT/$MYSQL_CONTAINER_PORT/g"   ./environment/webserver/mysql.yml
  sed -i "s/\$MYSQL_PASSWORD/$MYSQL_PASSWORD/g"               ./environment/webserver/mysql.yml
  sed -i "s/\$MYSQL_DATABASE/student/g"                       ./environment/webserver/mysql.yml

  logDebug "modifyEnvVar end"
}

function MAIN() 
{
  logError "${0}:modify_env_var begin"
  modifyEnvVar
  logDebug "${0}:modify_env_var end"
}

MAIN

if [ $? -ne 0 ];then
  echo "check ${0} fail"
  exit 1
else
  echo "check ${0} success"
fi