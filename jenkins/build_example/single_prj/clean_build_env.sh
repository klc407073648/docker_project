#!/bin/bash
source ./common.sh

#全局变量
cur_path=`pwd`

function cleanBuildEnv() {
    logDebug "cleanBuildEnv begin"

    cd ${cur_path}

    rm -rf ./download
    rm -rf ./logs

    logDebug "cleanBuildEnv end"
}

function MAIN() {
  logDebug "MAIN begin"
  cleanBuildEnv
  logDebug "MAIN end"
}

MAIN