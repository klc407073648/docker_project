#!/bin/bash
cur_path='/home/jenkins/test/'
cd ${cur_path}

rm -rf ./single_prj
rm -rf ./docker_project

if [ ! -d ${cur_path}/bak ]; then
    mkdir -p ${cur_path}/bak
    cp ./build.sh ${cur_path}/bak
fi

git clone git@github.com:klc407073648/docker_project.git || ("git docker_project fail" && exit 1)

cp -rf ./docker_project/jenkins/build_example/single_prj  ${cur_path}

cd ./single_prj
chmod 777 *.sh && dos2unix *.sh

cd ./build
chmod 777 *.sh && dos2unix *.sh