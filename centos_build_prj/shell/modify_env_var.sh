config_file=env_config

function parseConfigFile()
{
   echo "parseConfigFile begin" 
   echo "parse var from $config_file"

   MYSQL_IP=`cat $config_file |grep "MYSQL_IP=" |cut -f2 -d'='`
   MYSQL_PORT=`cat $config_file |grep "MYSQL_PORT=" |cut -f2 -d'='`
   MYSQL_DATABASE=`cat $config_file |grep "MYSQL_DATABASE=" |cut -f2 -d'='`
   MYSQL_USER=`cat $config_file |grep "MYSQL_USER=" |cut -f2 -d'='`
   MYSQL_PASSWORD=`cat $config_file |grep "MYSQL_PASSWORD=" |cut -f2 -d'='`

   REDIS_IP=`cat $config_file |grep "REDIS_IP=" |cut -f2 -d'='`
   REDIS_PORT=`cat $config_file |grep "REDIS_PORT=" |cut -f2 -d'='`
   REDIS_DATABASE=`cat $config_file |grep "REDIS_DATABASE=" |cut -f2 -d'='`
   REDIS_PASSWORD=`cat $config_file |grep "REDIS_PASSWORD=" |cut -f2 -d'='`

   FRIENDFINDER_BACKEND_IP=`cat $config_file |grep "FRIENDFINDER_BACKEND_IP=" |cut -f2 -d'='`
   FRIENDFINDER_BACKEND_PORT=`cat $config_file |grep "FRIENDFINDER_BACKEND_PORT=" |cut -f2 -d'='`

   echo "MYSQL_IP=$MYSQL_IP"
   echo "MYSQL_PORT=$MYSQL_PORT"
   echo "MYSQL_DATABASE=$MYSQL_DATABASE"
   echo "MYSQL_USER=$MYSQL_USER"
   echo "MYSQL_PASSWORD=$MYSQL_PASSWORD"

   echo "REDIS_IP=$REDIS_IP"
   echo "REDIS_PORT=$REDIS_PORT"
   echo "REDIS_DATABASE=$REDIS_DATABASE"
   echo "REDIS_PASSWORD=$REDIS_PASSWORD"

   echo "FRIENDFINDER_BACKEND_IP=$FRIENDFINDER_BACKEND_IP"
   echo "FRIENDFINDER_BACKEND_PORT=$FRIENDFINDER_BACKEND_PORT"

   echo "parseConfigFile end"
}

function modifyEnvVar() 
{
    echo "begin to modifyEnvVar"

    filePath=$1
    fileName=$2
	echo "filePath:$filePath"
	echo "fileName:$fileName"
    
    cd ${filePath}

    sed -i "s/\$MYSQL_IP/$MYSQL_IP/g" ${fileName}
    sed -i "s/\$MYSQL_PORT/$MYSQL_PORT/g" ${fileName}
    sed -i "s/\$MYSQL_DATABASE/$MYSQL_DATABASE/g" ${fileName}
    sed -i "s/\$MYSQL_USER/$MYSQL_USER/g" ${fileName}
    sed -i "s/\$MYSQL_PASSWORD/$MYSQL_PASSWORD/g" ${fileName}

    sed -i "s/\$REDIS_IP/$REDIS_IP/g" ${fileName}
    sed -i "s/\$REDIS_PORT/$REDIS_PORT/g" ${fileName}
    sed -i "s/\$REDIS_DATABASE/$REDIS_DATABASE/g" ${fileName}
    sed -i "s/\$REDIS_PASSWORD/$REDIS_PASSWORD/g" ${fileName}

    sed -i "s/\$FRIENDFINDER_BACKEND_IP/$FRIENDFINDER_BACKEND_IP/g" ${fileName}
    sed -i "s/\$FRIENDFINDER_BACKEND_PORT/$FRIENDFINDER_BACKEND_PORT/g" ${fileName}

    echo "end to modifyEnvVar"
}

function MAIN()
{
   parseConfigFile
   modifyEnvVar $1 $2
}

MAIN $1 $2