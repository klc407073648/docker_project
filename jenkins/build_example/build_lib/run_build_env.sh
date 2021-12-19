#!/bin/bash
source ./common.sh

#全局变量
download_code_path=`pwd`/download

function printEnvInfo() {
    logDebug "printEnvInfo begin"

    if [ ! -d ${download_code_path} ]; then
        mkdir -p ${download_code_path}
    fi

    logError "download_code_path:[${download_code_path}]"

    logDebug "printEnvInfo end"
}

function buildLib() {
    logDebug "buildLib begin"

    cd $download_code_path/build_lib/

    cd ./build && chmod 777 *.sh && dos2unix *.sh
    docker run -it -d -v ${download_code_path}/build_lib:/home/tools/build_lib --name centos_build_lib_0 docker.io/klc407073648/centos_build_lib:v3.0 /bin/bash
    docker exec -i centos_build_lib_0 /bin/sh -c "cd /home/tools/build_lib/build && ./build.sh"
	
	build_tar_name=`ls |grep StiBel`
	cp -rf ${download_code_path}/build_lib/output/${build_tar_name} ${download_code_path}/StiBel

    docker stop centos_build_lib_0
    docker rm centos_build_lib_0

    docker-compose up -d
    docker exec -i stibel_webserver_0 /bin/sh -c "cd /home/tools/StiBel/DockerBuild && ./buildMyPrj.sh"


    logDebug "buildLib end"
}

function buildWeb() {
    logDebug "buildWeb begin"

    cd $download_code_path/docker_project/

    cd ./nginx && chmod 777 *.sh && dos2unix *.sh

    ./build_nginx.sh

    cd ./environment/html/ && tar -zxf web.tar.gz

    logDebug "buildWeb end"
}

function buildMySQL() {
    logDebug "buildMySQL begin"

    cd $download_code_path/docker_project/

    cd ./mysql && chmod 777 *.sh && dos2unix *.sh

    ./build_mysql.sh

    logDebug "buildMySQL end"
}

function buildStiBel() {
    logDebug "buildStiBel begin"

    cd $download_code_path/StiBel/

    chmod 777 *.sh && dos2unix *.sh

    buildTime=$(date +"%Y%m%d")

    cp $download_code_path/build_lib/output/StiBel_${buildTime}.tar.gz ${download_code_path}/StiBel ##拷贝buildLib的库文件

    docker run -it -d -p 9950:9950 -v ${download_code_path}/StiBel:/home/tools/StiBel --name centos_stibel_0 docker.io/klc407073648/centos_build_lib:v3.0 /bin/bash
    docker exec -i centos_stibel_0 /bin/sh -c "cd /home/tools/StiBel && ./buildMyPrj.sh"

    logDebug "buildStiBel end"
}

function MAIN() {
    logDebug "MAIN begin"
    printEnvInfo
    buildLib
    logDebug "MAIN end"
}

MAIN
