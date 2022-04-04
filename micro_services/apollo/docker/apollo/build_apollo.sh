#/bin/bash
function modify_env_var() 
{
    echo "begin to modify_env_var"

    sed -i "s/\$MYSQL_HOST_IP/139.196.82.84/g" ./environment/apollo.env
    sed -i "s/\$MYSQL_PORT/3308/g" ./environment/apollo.env
    sed -i "s/\$META_SERVICE_IP/139.196.82.84/g" ./environment/apollo.env

    echo "end to modify_env_var"
}

function build_apollo() 
{
    echo "begin to build_apollo"

    cp ./environment/apollo.env .env
    docker-compose up -d

    echo "end to build_apollo"
}

modify_env_var
build_apollo