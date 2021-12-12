#!/bin/bash
cd ./build_lib/build && chmod 777 *.sh && dos2unix *.sh

docker run -it -d -v /home/jenkins/workspace/build_lib:/home/tools/build_lib --name centos_build_lib_0 docker.io/klc407073648/centos_build_lib:v3.0 /bin/bash
docker exec -i centos_build_lib_0 /bin/sh -c "cd /home/tools/build_lib/build &&./build.sh"
