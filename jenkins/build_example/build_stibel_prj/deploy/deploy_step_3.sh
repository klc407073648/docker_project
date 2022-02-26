#!/bin/bash
source ./common.sh

#全局变量
cur_path=`pwd`

function copyFiles() 
{
    logDebug "copyFiles begin"

	cd ${cur_path}/../output

    build_tar_name=`ls |grep StiBel_Prj |tail -1`
	
	cp -rf ./${build_tar_name} $cur_path/environment/webserver/StiBel_Prj.tar.gz || (logError "cp StiBel_Prj fail" && exit 1)
    cp -rf ./libstdc++.so.6.0.26 $cur_path/environment/webserver/   || (logError "cp libstdc++ fail" && exit 1)
    
    logDebug "copyFiles end"
}

function deployStiBelProject() 
{
    logDebug "deployStiBelProject begin"

	cd ${cur_path}
	
	net_name=`docker network ls |grep "stibel_net" |awk '{print $2}'`
	docker network rm $net_name
    docker-compose up -d

    checkExecResult "docker-compose fail"

    cd ${cur_path}/data/nginx/html/ && tar -zxf web.tar.gz

	#还是要进入容器来解决
	#root        21     0  0 23:41 ?        00:00:00 [webServer_main] <defunct>
	#root        22     0  0 23:41 ?        00:00:00 ./rrbroker_main
	#root        23     0  0 23:41 ?        00:00:00 ./rrserver_main
	#root        41     0  0 23:41 ?        00:00:00 /bin/bash ./swd.sh

    #docker exec -i stibel_webserver_0 /bin/sh -c "cd /home/StiBel/DockerBuild && ./run.sh"
    
    logDebug "deployStiBelProject end"
}

function MAIN() 
{
    logError "${0}:deploy_stibel_prj begin"
    copyFiles
    deployStiBelProject
    logError "${0}:deploy_stibel_prj begin"
}

MAIN

if [ $? -ne 0 ];then
  echo "check ${0} fail"
  exit 1
else
  echo "check ${0} success"
fi