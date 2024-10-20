#/bin/bash
project_name='stibel'
HOST_MACHINE_IP='81.68.132.31'
WEB_CONTAINER_PORT='80'

function modify_env_var() 
{
    echo "begin to modify_env_var"

    sed -i "s/\$HOST_MACHINE_IP/$HOST_MACHINE_IP/g"        ./environment/conf.d/default.conf
    sed -i "s/\$WEB_CONTAINER_PORT/$WEB_CONTAINER_PORT/g"  ./environment/conf.d/default.conf

    echo "end to modify_env_var"
}

function build_docker_project()
{
    docker_name=$1
    docker_name_tar=$2
    echo "begin to clear environment ${project_name}_${docker_name}"

    docker stop $(docker ps |grep ${project_name}_${docker_name}_0 |awk '{print $1}')
    docker rm $(docker ps -q -f status=exited)
    docker rmi ${project_name}_${docker_name}:${docker_name_tar}

    echo "end to clear environment ${project_name}_${docker_name}"

    echo "begin to build ${project_name}_${docker_name}"

    cp ./environment/${docker_name}.env .env

    docker-compose up -d

    echo "end to build ${project_name}_${docker_name}"
}

modify_env_var
build_docker_project "nginx" "v1.0"