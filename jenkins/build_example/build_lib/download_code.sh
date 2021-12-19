#!/bin/bash
source ./common.sh

#全局变量
download_code_path=`pwd`/download
build_lib_git_path='git@github.com:klc407073648/build_lib.git'
stibel_git_path='git@github.com:klc407073648/StiBel.git'
docker_project_git_path='git@github.com:klc407073648/docker_project.git'

download_code_list='build_lib StiBel docker_project'

function printEnvInfo() {
    logDebug "printEnvInfo begin"

    if [ ! -d ${download_code_path} ]; then
        mkdir -p ${download_code_path}
    fi

    logWarn "download_code_path:[${download_code_path}]"

    logInfo "build_lib_git_path:[${build_lib_git_path}]"
    logInfo "stibel_git_path:[${stibel_git_path}]"
    logInfo "docker_project_git_path:[${docker_project_git_path}]"

    logError "download_code_list:[${download_code_list}]"

    logDebug "printEnvInfo end"
}

function downloadCode() {
    logDebug "downloadCode begin"

    cd $download_code_path

    for cur_code in $download_code_list; do
        logInfo "${cur_code} download begin"

        rm -rf ./${cur_code}
        git clone git@github.com:klc407073648/${cur_code}.git

        logInfo "${cur_code} download end"
    done

    logDebug "downloadCode end"
}

function MAIN() {
    logDebug "MAIN begin"
    printEnvInfo
    downloadCode
    logDebug "MAIN end"
}

MAIN
