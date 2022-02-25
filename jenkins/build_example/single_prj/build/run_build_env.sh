#!/bin/bash
source ./common.sh

#全局变量
cur_path=`pwd`

function copyFiles() 
{
    logDebug "copyFiles begin"

	cd ${cur_path}/..

    build_tar_name=`ls |grep StiBel_Prj |tail -1`
	
	cp -rf ./${build_tar_name} $cur_path/environment/webserver/StiBel_Prj.tar.gz
    cp -rf ./libstdc++.so.6.0.26 $cur_path/environment/webserver/

    checkBuildResult "copyFiles"
    
    logDebug "copyFiles end"
}

function buildStiBelProject() 
{
    logDebug "buildStiBelProject begin"

	cd ${cur_path}
	
	net_name=`docker network ls |grep "stibel_net" |awk '{print $2}'`
	docker network rm $net_name
    docker-compose up -d

    checkBuildResult "docker-compose_up"

    cd ${cur_path}/data/nginx/html/ && tar -zxf web.tar.gz

	#还是要进入容器来解决
	#root        21     0  0 23:41 ?        00:00:00 [webServer_main] <defunct>
	#root        22     0  0 23:41 ?        00:00:00 ./rrbroker_main
	#root        23     0  0 23:41 ?        00:00:00 ./rrserver_main
	#root        41     0  0 23:41 ?        00:00:00 /bin/bash ./swd.sh

    #docker exec -i stibel_webserver_0 /bin/sh -c "cd /home/StiBel/DockerBuild && ./run.sh"
    
    logDebug "buildStiBelProject end"
}

function MAIN() 
{
    logDebug "MAIN begin"
    copyFiles
    buildStiBelProject
    logDebug "MAIN end"
}

MAIN