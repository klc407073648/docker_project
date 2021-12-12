#!/bin/bash
build_list='centos_build_lib_0 centos_build_lib_1'

function clean_build_env()
{
   sum=0
   for build_name in $build_list  
   do 
      cnt=`docker ps -a |grep $build_name |wc -l`
      if [ "$cnt"x = "1"x ];then
        sum=`expr $sum + $cnt` 
        docker stop $build_name
      fi
   done

   if [ "$sum"x != "0"x ];then
     docker rm $(docker ps -q -f status=exited)
   fi
}

clean_build_env