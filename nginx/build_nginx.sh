#/bin/bash
source ../common.sh

cd ./environment/html && tar -zxvf web.tar.gz
build_docker_project "nginx" "v1.0"