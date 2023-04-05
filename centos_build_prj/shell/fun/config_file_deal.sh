cur=`pwd`
common_config_file=${cur}/conf/common_config
prj_config_file=${cur}/conf/prj_config

function parseCommonConfigFile() {
    echo "[$FUNCNAME] begin"
    echo "[$FUNCNAME] parse var from $common_config_file"

    export MYSQL_IP=$(cat $common_config_file | grep "MYSQL_IP=" | cut -f2 -d'=')
    export MYSQL_PORT=$(cat $common_config_file | grep "MYSQL_PORT=" | cut -f2 -d'=')
    export MYSQL_USER=$(cat $common_config_file | grep "MYSQL_USER=" | cut -f2 -d'=')
    export MYSQL_PASSWORD=$(cat $common_config_file | grep "MYSQL_PASSWORD=" | cut -f2 -d'=')

    export REDIS_IP=$(cat $common_config_file | grep "REDIS_IP=" | cut -f2 -d'=')
    export REDIS_PORT=$(cat $common_config_file | grep "REDIS_PORT=" | cut -f2 -d'=')
    export REDIS_DATABASE=$(cat $common_config_file | grep "REDIS_DATABASE=" | cut -f2 -d'=')
    export REDIS_PASSWORD=$(cat $common_config_file | grep "REDIS_PASSWORD=" | cut -f2 -d'=')

    echo "[$FUNCNAME] MySQL info: ip=$MYSQL_IP, port=$MYSQL_PORT, user=$MYSQL_USER, password=$MYSQL_PASSWORD"

    echo "[$FUNCNAME] Redis info: ip=$REDIS_IP, port=$REDIS_PORT, database=$REDIS_DATABASE, password=$REDIS_PASSWORD"

    echo "[$FUNCNAME] end"
}

function parsePrjConfigFile() {
    echo "[$FUNCNAME] begin"
    echo "[$FUNCNAME] parse var from $prj_config_file"

    export USERCENTER_FRONTEND_IP=$(cat $prj_config_file | grep "USERCENTER_FRONTEND_IP=" | cut -f2 -d'=')
    export USERCENTER_FRONTEND_PORT=$(cat $prj_config_file | grep "USERCENTER_FRONTEND_PORT=" | cut -f2 -d'=')
    export USERCENTER_BACKEND_IP=$(cat $prj_config_file | grep "USERCENTER_BACKEND_IP=" | cut -f2 -d'=')
    export USERCENTER_BACKEND_PORT=$(cat $prj_config_file | grep "USERCENTER_BACKEND_PORT=" | cut -f2 -d'=')
    export USERCENTER_BACKEND_DATABASE=$(cat $prj_config_file | grep "USERCENTER_BACKEND_DATABASE=" | cut -f2 -d'=')

    export FRIENDFINDER_FRONTEND_IP=$(cat $prj_config_file | grep "FRIENDFINDER_FRONTEND_IP=" | cut -f2 -d'=')
    export FRIENDFINDER_FRONTEND_PORT=$(cat $prj_config_file | grep "FRIENDFINDER_FRONTEND_PORT=" | cut -f2 -d'=')
    export FRIENDFINDER_BACKEND_IP=$(cat $prj_config_file | grep "FRIENDFINDER_BACKEND_IP=" | cut -f2 -d'=')
    export FRIENDFINDER_BACKEND_PORT=$(cat $prj_config_file | grep "FRIENDFINDER_BACKEND_PORT=" | cut -f2 -d'=')
    export FRIENDFINDER_BACKEND_DATABASE=$(cat $prj_config_file | grep "FRIENDFINDER_BACKEND_DATABASE=" | cut -f2 -d'=')

    export OPENAPI_FRONTEND_IP=$(cat $prj_config_file | grep "OPENAPI_FRONTEND_IP=" | cut -f2 -d'=')
    export OPENAPI_FRONTEND_PORT=$(cat $prj_config_file | grep "OPENAPI_FRONTEND_PORT=" | cut -f2 -d'=')
    export OPENAPI_BACKEND_IP=$(cat $prj_config_file | grep "OPENAPI_BACKEND_IP=" | cut -f2 -d'=')
    export OPENAPI_BACKEND_PORT=$(cat $prj_config_file | grep "OPENAPI_BACKEND_PORT=" | cut -f2 -d'=')
    export OPENAPI_BACKEND_DATABASE=$(cat $prj_config_file | grep "OPENAPI_BACKEND_DATABASE=" | cut -f2 -d'=')

    export CMD_TERMINAL_FRONTEND_IP=$(cat $prj_config_file | grep "CMD_TERMINAL_FRONTEND_IP=" | cut -f2 -d'=')
    export CMD_TERMINAL_FRONTEND_PORT=$(cat $prj_config_file | grep "CMD_TERMINAL_FRONTEND_PORT=" | cut -f2 -d'=')
    export CMD_TERMINAL_BACKEND_IP=$(cat $prj_config_file | grep "CMD_TERMINAL_BACKEND_IP=" | cut -f2 -d'=')
    export CMD_TERMINAL_BACKEND_PORT=$(cat $prj_config_file | grep "CMD_TERMINAL_BACKEND_PORT=" | cut -f2 -d'=')
    export CMD_TERMINAL_BACKEND_DATABASE=$(cat $prj_config_file | grep "CMD_TERMINAL_BACKEND_DATABASE=" | cut -f2 -d'=')

    echo "[$FUNCNAME] userCenter info: front_ip=$USERCENTER_FRONTEND_IP, front_port=$USERCENTER_FRONTEND_PORT,  \
   back_ip=$USERCENTER_BACKEND_IP, back_port=$USERCENTER_BACKEND_PORT, back_databse=$USERCENTER_BACKEND_DATABASE"

    echo "[$FUNCNAME] friendFinder info: front_ip=$FRIENDFINDER_FRONTEND_IP, front_port=$FRIENDFINDER_FRONTEND_PORT,  \
   back_ip=$FRIENDFINDER_BACKEND_IP, back_port=$FRIENDFINDER_BACKEND_PORT, back_databse=$FRIENDFINDER_BACKEND_DATABASE"

    echo "[$FUNCNAME] openApi info: front_ip=$OPENAPI_FRONTEND_IP, front_port=$OPENAPI_FRONTEND_PORT,  \
   back_ip=$OPENAPI_BACKEND_IP, back_port=$OPENAPI_BACKEND_PORT, back_databse=$OPENAPI_BACKEND_DATABASE"

    echo "[$FUNCNAME] cmd-terminal info: front_ip=$CMD_TERMINAL_FRONTEND_IP, front_port=$CMD_TERMINAL_FRONTEND_PORT,  \
   back_ip=$CMD_TERMINAL_BACKEND_IP, back_port=$CMD_TERMINAL_BACKEND_PORT, back_databse=$CMD_TERMINAL_BACKEND_DATABASE"

    echo "[$FUNCNAME] parsePrjConfigFile end"
}

function parseConfigFile() {
    parseCommonConfigFile
    parsePrjConfigFile
}

function modifyCommonVar() {
    echo "[$FUNCNAME] begin"

    filePath=$1
    fileName=$2
    prjName=$3

    echo "[$FUNCNAME] modifyCommonVar filePath:$filePath, fileName:$fileName, prjName:$prjName"

    cd ${filePath}

    sed -i "s/\$MYSQL_IP/$MYSQL_IP/g" ${fileName}
    sed -i "s/\$MYSQL_PORT/$MYSQL_PORT/g" ${fileName}
    sed -i "s/\$MYSQL_USER/$MYSQL_USER/g" ${fileName}
    sed -i "s/\$MYSQL_PASSWORD/$MYSQL_PASSWORD/g" ${fileName}

    sed -i "s/\$REDIS_IP/$REDIS_IP/g" ${fileName}
    sed -i "s/\$REDIS_PORT/$REDIS_PORT/g" ${fileName}
    sed -i "s/\$REDIS_DATABASE/$REDIS_DATABASE/g" ${fileName}
    sed -i "s/\$REDIS_PASSWORD/$REDIS_PASSWORD/g" ${fileName}

    echo "[$FUNCNAME] end"
}

function modifyPrjVar() {
    echo "[$FUNCNAME] begin"

    filePath=$1
    fileName=$2
    prjName=$3

    echo "[$FUNCNAME] modifyPrjVar filePath:$filePath, fileName:$fileName, prjName:$prjName"

    cd ${filePath}

    if [ "$prjName"x = "userCenter"x ]; then
        sed -i "s/\$USERCENTER_FRONTEND_IP/$USERCENTER_FRONTEND_IP/g" ${fileName}
        sed -i "s/\$USERCENTER_FRONTEND_PORT/$USERCENTER_FRONTEND_PORT/g" ${fileName}
        sed -i "s/\$USERCENTER_BACKEND_IP/$USERCENTER_BACKEND_IP/g" ${fileName}
        sed -i "s/\$USERCENTER_BACKEND_PORT/$USERCENTER_BACKEND_PORT/g" ${fileName}
        sed -i "s/\$USERCENTER_BACKEND_DATABASE/$USERCENTER_BACKEND_DATABASE/g" ${fileName}
    elif [ "$prjName"x = "friendFinder"x ]; then
        sed -i "s/\$FRIENDFINDER_FRONTEND_IP/$FRIENDFINDER_FRONTEND_IP/g" ${fileName}
        sed -i "s/\$FRIENDFINDER_FRONTEND_PORT/$FRIENDFINDER_FRONTEND_PORT/g" ${fileName}
        sed -i "s/\$FRIENDFINDER_BACKEND_IP/$FRIENDFINDER_BACKEND_IP/g" ${fileName}
        sed -i "s/\$FRIENDFINDER_BACKEND_PORT/$FRIENDFINDER_BACKEND_PORT/g" ${fileName}
        sed -i "s/\$FRIENDFINDER_BACKEND_DATABASE/$FRIENDFINDER_BACKEND_DATABASE/g" ${fileName}
    elif [ "$prjName"x = "openApi"x ]; then
        sed -i "s/\$OPENAPI_FRONTEND_IP/$OPENAPI_FRONTEND_IP/g" ${fileName}
        sed -i "s/\$OPENAPI_FRONTEND_PORT/$OPENAPI_FRONTEND_PORT/g" ${fileName}
        sed -i "s/\$OPENAPI_BACKEND_IP/$OPENAPI_BACKEND_IP/g" ${fileName}
        sed -i "s/\$OPENAPI_BACKEND_PORT/$OPENAPI_BACKEND_PORT/g" ${fileName}
        sed -i "s/\$OPENAPI_BACKEND_DATABASE/$OPENAPI_BACKEND_DATABASE/g" ${fileName}
    elif [ "$prjName"x = "cmd-terminal"x ]; then
        sed -i "s/\$CMD_TERMINAL_FRONTEND_IP/$CMD_TERMINAL_FRONTEND_IP/g" ${fileName}
        sed -i "s/\$CMD_TERMINAL_FRONTEND_PORT/$CMD_TERMINAL_FRONTEND_PORT/g" ${fileName}
        sed -i "s/\$CMD_TERMINAL_BACKEND_IP/$CMD_TERMINAL_BACKEND_IP/g" ${fileName}
        sed -i "s/\$CMD_TERMINAL_BACKEND_PORT/$CMD_TERMINAL_BACKEND_PORT/g" ${fileName}
        sed -i "s/\$CMD_TERMINAL_BACKEND_DATABASE/$CMD_TERMINAL_BACKEND_DATABASE/g" ${fileName}
    fi

    echo "[$FUNCNAME] end"
}

function modifyFileVar() {
    modifyCommonVar $1 $2 $3
    modifyPrjVar $1 $2 $3
}
