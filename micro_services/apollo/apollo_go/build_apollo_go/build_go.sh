#/bin/bash
docker rm $(docker ps -q -f status=exited)
docker rmi docker.io/klc407073648/centos_build_go:v1.0

dos2unix *.sh
chmod 777 *.sh

docker build -t docker.io/klc407073648/centos_build_go:v1.0 .
