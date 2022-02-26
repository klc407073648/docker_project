#!/bin/bash
source ./common.sh

#全局变量
cur_path=`pwd`

logDebug "build.sh begin"

./clean_build_env.sh || (logError "clean_build_env fail" && exit 1)
./modify_env_var.sh || (logError "modify_env_var fail" && exit 1)
./run_build_env.sh || (logError "run_build_env fail" && exit 1)

logDebug "build.sh end"