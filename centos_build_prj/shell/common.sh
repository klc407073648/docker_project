#注意大写的全是宏定义值

# 项目名称、当前路径、构建镜像版本，运行容器后缀
export project_name=stibel
export cur_path=`pwd`
export image_tar='v0.0.1'
export suf_num='0'

# 构建前端环境
export frontend_container_name="${project_name}_build_frontend_${suf_num}"
export frontend_image_name='docker.io/klc407073648/centos_build_frontend:v1.0'

# 构建后端环境
# java后端环境
export java_backend_container_name="${project_name}_build_java_backend_${suf_num}"
export java_backend_image_name='docker.io/klc407073648/centos_build_jdk_backend:v1.0'

# cpp后端环境
export cpp_backend_container_name="${project_name}_build_cpp_backend_${suf_num}"
export cpp_backend_image_name='docker.io/klc407073648/centos_build_lib:v3.0'

# 构建容器列表、代码库下载路径、构建代码列表
export container_list="${frontend_container_name} ${java_backend_container_name} ${cpp_backend_container_name}"
export image_list="${frontend_image_name} ${java_backend_image_name} ${cpp_backend_image_name}"
export code_download_path=${cur_path}/download
export code_list='friendFinder' #userCenter openApi cmd-terminal

export deploy_container_list='user-center-frontend user-center-backend'

#日志路径、日志文件、日志级别
log_dir=$cur_path/logs
log_file=$log_dir/my.log
log_level=4

#日志路径、日志文件、日志级别
log_dir=$cur_path/logs
log_file=$log_dir/my.log
log_level=4

#日志级别
logDebugNum=4
logInfoNum=3
logWarnNum=2
logErrorNum=1

#是否保存日志
isSave=1

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

# Debug日志
function logDebug()
{
   if [ $log_level -ge $logDebugNum ];then 
      echo -e "\033[32m-- $1 --\033[0m"
   fi

   if [ $isSave -eq 1 ];then 
      write_log "$1"
   fi
}

# Info日志
function logInfo()
{
   if [ $log_level -ge $logInfoNum ];then 
      echo -e "\033[36m-- $1 --\033[0m"
   fi

   if [ $isSave -eq 1 ];then 
      write_log "$1"
   fi
}

# Warn日志
function logWarn()
{
   if [ $log_level -ge $logWarnNum ];then 
      echo -e "\033[33m-- $1 --\033[0m"
   fi

   if [ $isSave -eq 1 ];then 
      write_log "$1"
   fi
}

# Error日志
function logError()
{
   if [ $log_level -ge $logErrorNum ];then
      echo -e "\033[31m-- $1 --\033[0m"
   fi

   if [ $isSave -eq 1 ];then 
      write_log "$1"
   fi
}

# 清理运行的容器
function cleanRunContainer() 
{
  logDebug "cleanRunContainer begin"

  sum=0
  for container_name in $container_list; do
    cnt=$(docker ps -a | grep $container_name | wc -l)
    if [ "$cnt"x = "1"x ]; then
      sum=`expr $sum + $cnt`
      logInfo "docker stop $container_name"
      docker stop $container_name
    fi
  done

  if [ "$sum"x != "0"x ]; then
    docker rm $(docker ps -q -f status=exited)
  fi

  logDebug "cleanRunContainer end"
}

# 校验执行结果
function checkExecResult()
{
   if [ $? -ne 0 ];then
       write_log "check $1 fail"  && logError "check $1 fail"
       exit 1
   else
       write_log "check $1 success"  && logInfo "check $1 success"
   fi
}


# 校验执行结果
function checkMainResult()
{
   if [ $? -ne 0 ];then
      echo "check ${0} fail"
      exit 1
   else
      echo "check ${0} success"
   fi
}