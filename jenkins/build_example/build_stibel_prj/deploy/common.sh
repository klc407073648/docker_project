#注意大写的全是宏定义值

#当前路径
export cur_path=`pwd`

#部署容器,部署镜像名，配置文件
export deploy_container_list='stibel_nginx_web_0 stibel_mysql_0 stibel_webserver_0'  
export deploy_image_name_list='stibel_nginx_web stibel_mysql stibel_webserver'
export config_file='.env'

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
function logDebug()
{
   if [ $log_level -ge $logDebugNum ];then 
      echo -e "\033[32m-- $1 --\033[0m"
   fi

   if [ $isSave -eq 1 ];then 
      write_log "$1"
   fi
}

function logInfo()
{
   if [ $log_level -ge $logInfoNum ];then 
      echo -e "\033[36m-- $1 --\033[0m"
   fi

   if [ $isSave -eq 1 ];then 
      write_log "$1"
   fi
}

function logWarn()
{
   if [ $log_level -ge $logWarnNum ];then 
      echo -e "\033[33m-- $1 --\033[0m"
   fi

   if [ $isSave -eq 1 ];then 
      write_log "$1"
   fi
}

function logError()
{
   if [ $log_level -ge $logErrorNum ];then
      echo -e "\033[31m-- $1 --\033[0m"
   fi

   if [ $isSave -eq 1 ];then 
      write_log "$1"
   fi
}

function checkExecResult()
{
   if [ $? -ne 0 ];then
       write_log "check $1 fail"  && logError "check $1 fail"
       exit 1
   else
       write_log "check $1 success"  && logInfo "check $1 success"
   fi
}