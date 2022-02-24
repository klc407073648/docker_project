#!/bin/bash
source ./common.sh

#全局变量
cur_path=`pwd`
build_container_name='stibel_run_web_0'

#构建build_lib任务生成公共库
function runStibelPrj() 
{
    logDebug "runStibelPrj begin"

    cd $cur_path

    docker stop ${build_container_name}
    docker rm ${build_container_name}
    
    docker run -it -d --name ${build_container_name} centos:centos7 /bin/bash

    build_tar_name=`ls |grep StiBel_Prj |tail -1`

    docker cp ./${build_tar_name} ${build_container_name}:/home
    docker cp ./libstdc++.so.6.0.26 ${build_container_name}:/home

    rm -rf ./run_stibel.sh 
    echo "mkdir -p /home/StiBel && cd /home/StiBel && cp ../${build_tar_name} . && tar -zxvf ./${build_tar_name} ." >> ./run_stibel.sh 
    echo "cd /home/StiBel/conf/etc/ld.so.conf.d/ && sed -i 's/\/home\/project/\/home/' mylib.conf" >> ./run_stibel.sh 
    echo "cp -rf mylib.conf /etc/ld.so.conf.d/" >> ./run_stibel.sh 
    echo "yum -y install mysql-devel openssl-devel libnsl" >> ./run_stibel.sh 
    echo "cp -r /usr/lib64/mysql/* /usr/lib/" >> ./run_stibel.sh
    echo "rm -rf /lib64/libstdc++.so.6.0.19" >> ./run_stibel.sh 
    echo "rm -rf /lib64/libstdc++.so.6" >> ./run_stibel.sh 
    echo "ln -sf /home/libstdc++.so.6.0.26 /lib64/libstdc++.so.6" >> ./run_stibel.sh
    echo "ldconfig" >> ./run_stibel.sh 

    chmod 777 run_stibel.sh && dos2unix run_stibel.sh 
    docker cp ./run_stibel.sh  ${build_container_name}:/home

    docker exec -i ${build_container_name} /bin/sh -c "cd /home && ./run_stibel.sh"

    #docker stop ${build_container_name}
    #docker rm ${build_container_name}

    logDebug "runStibelPrj end"
}

function MAIN() 
{
  logDebug "run_stibel_prj.sh MAIN begin"
  runStibelPrj
  logDebug "run_stibel_prj.sh MAIN end"
}

MAIN