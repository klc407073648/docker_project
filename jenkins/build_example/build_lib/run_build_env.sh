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
    docker exec -i centos_build_lib_0 /bin/sh -c "source /etc/profile && cd /home/tools/build_lib/build && ./build.sh"
	
    cd $download_code_path/build_lib/output

	build_tar_name=`ls |grep StiBel`
	cp -rf ${download_code_path}/build_lib/output/${build_tar_name} ${download_code_path}/StiBel

    docker stop centos_build_lib_0
    docker rm centos_build_lib_0

    logDebug "buildLib end"
}

function buildStiBelProject() {
    logDebug "buildStiBelProject begin"

	cd ${download_code_path}/..
	
	net_name=`docker network ls |grep "stibel_net" |awk '{print $2}'`
	docker network rm $net_name
    docker-compose up -d

    cd ${download_code_path}/../data/nginx/html/ && tar -zxf web.tar.gz

    mkdir -p ${download_code_path}/../data/webserver/data/StiBel
    cp -rf ${download_code_path}/StiBel/*   ${download_code_path}/../data/webserver/data/StiBel
	
	cd ${download_code_path}/../data/webserver/data/StiBel/DockerBuild/
	
	chmod 777 *.sh && dos2unix *.sh
	
	#进入容器后手动操作，可以用
    # root       349     0  0 20:47 ?        00:00:00 [rrserver_main] <defunct>
    #待解决，目前只能最后手动进入容器执行对应命令，从宿主机执行后，进入容器kill对应进程变成僵尸进程，看门狗无法再次拉起来
    #docker exec -i stibel_webserver_0 /bin/sh -c "source /etc/profile && cd /home/tools/StiBel/DockerBuild && ./build.sh"
    
    logDebug "buildStiBelProject end"
}

function MAIN() {
    logDebug "MAIN begin"
    printEnvInfo
    #buildLib
    buildStiBelProject
    logDebug "MAIN end"
}

MAIN