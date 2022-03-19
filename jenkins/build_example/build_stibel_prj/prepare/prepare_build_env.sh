#!/bin/bash
source ./common.sh

cur_path='/home/jenkins/test/'
clean_path_list='prepare build deploy check'
code_git_name='docker_project'
code_git_path='git@github.com:klc407073648/docker_project.git'

function cleanEnvPath() 
{
    logDebug "cleanEnvPath begin"

    cd ${cur_path}

    mkdir -p ${cur_path}/output

    for clean_path in $clean_path_list; do
        if [ -d ${cur_path}/${clean_path} ]; then
            rm -rf ./${clean_path}
            logInfo "clean ${clean_path}"
        fi
    done

    logDebug "cleanEnvPath end"
}

function downloadCode() 
{
    logDebug "downloadCode begin"

    cd ${cur_path}

    rm -rf ./${code_git_name}
    git clone ${code_git_path}

    checkExecResult downloadCode

    logDebug "downloadCode end"
}

function copyNeedFiles() 
{
    logDebug "copyNeedFiles begin"

    cd ${cur_path}

    for copy_path in $clean_path_list; do
        cp -rf ./docker_project/jenkins/build_example/build_stibel_prj/${copy_path} ${cur_path} || (logError "cp ${copy_path} fail" && exit 1)
        logInfo "cp ${copy_path} success"
    done

    logDebug "copyNeedFiles end"
}

function modifyExecPermission() 
{
    logDebug "modifyExecPermission begin"

    for mod_path in $clean_path_list; do
        cd ${cur_path}/${mod_path}
        chmod 777 *.sh && dos2unix *.sh
    done

    logDebug "modifyExecPermission end"
}

function MAIN()
{
    logError "${0}:prepare_build_env begin"
    cleanEnvPath
    downloadCode
    copyNeedFiles
    modifyExecPermission
    logError "${0}:prepare_build_env end"
}

MAIN

if [ $? -ne 0 ]; then
    echo "check ${0} fail"
    exit 1
else
    echo "check ${0} success"
fi
