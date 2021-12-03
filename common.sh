#/bin/bash

#当前路径、构建docker
export cur_path=`pwd`
export build_docker_list='COMP_3PARTLIB_LIST'

export project_name='stibel'
export build_docker_name='docker_name'

#日志路径、日志文件、日志级别
log_dir=$cur_path/logs
log_file=$log_dir/build_docker.log
log_level=1

#写日志
function write_log()
{
  if [ ! -d ${log_dir} ];then
	 mkdir -p ${log_dir} 
  fi
  
  if [ ! -f ${log_file} ];then
	 touch  ${log_file} 
  fi
  
  fileCount=`ls ${log_dir}/*.log |wc -l`
  
  if [ ${fileCount} -gt 10 ];then
     find ${log_dir} -type f |xargs ls -tr | head -5 | xargs rm
  fi
  
  echo -n `date "+%Y-%m-%d %T "` >>${log_file}
  echo " $1" >>${log_file}
  
  return 0
}

#日志打印函数
#四个级别:Debug、Info、Warn、Error
function logDebug()
{
   if [ $log_level == 1 ];then 
      echo -e "\033[32m-- $1 --\033[0m"
   fi
}

function logInfo()
{
   if [ $log_level == 1 ];then 
      echo -e "\033[36m-- $1 --\033[0m"
   fi
}

function logWarn()
{
   echo -e "\033[33m-- $1 --\033[0m"
}

function logError()
{
   echo -e "\033[31m-- $1 --\033[0m"
}

#写日志且输出到控制台
function writeLogFileAndEcho()
{
   if [ "$2"x = ""x ];then
       write_log "$1"  && logDebug "$1"
   else
       write_log "$1"  && "$2" "$1"
   fi
}

function build_docker_project()
{
    docker_name=$1
    docker_name_tar=$2
    writeLogFileAndEcho "begin to clear environment ${project_name}_${docker_name}"

    docker stop $(docker ps |grep ${project_name}_${docker_name}_0 |awk '{print $1}')
    docker rm $(docker ps -q -f status=exited)
    docker rmi ${project_name}_${docker_name}:${docker_name_tar}

    writeLogFileAndEcho "end to clear environment ${project_name}_${docker_name}"

    writeLogFileAndEcho "begin to build ${project_name}_${docker_name}"

    cp ./environment/${docker_name}.env .env

    docker-compose up -d

    writeLogFileAndEcho "end to build ${project_name}_${docker_name}"
}