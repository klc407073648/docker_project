#!/bin/bash
source ./common.sh

function cleanBuildEnv() 
{
    logDebug "cleanBuildEnv begin"

    cd ${cur_path}

    rm -rf ./download
    rm -rf ./logs

    logDebug "cleanBuildEnv end"
}

function MAIN() 
{
  logError "${0}:clean_before_build begin"
  cleanBuildEnv
  cleanRunContainer
  logError "${0}:clean_before_build end"
}

MAIN

checkMainResult