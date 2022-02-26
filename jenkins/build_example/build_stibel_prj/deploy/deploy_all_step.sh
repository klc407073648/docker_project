#!/bin/bash
source ./common.sh

#全局变量
cur_path=`pwd`

logDebug "build.sh begin"

./deploy_step_1.sh || (logError "clean_build_env fail" && exit 1)
./deploy_step_2.sh || (logError "modify_env_var fail" && exit 1)
./deploy_step_3.sh || (logError "deploy_stibel_prj fail" && exit 1)

logDebug "build.sh end"