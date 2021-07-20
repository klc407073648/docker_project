#/bin/bash
docker stop $(docker ps |grep mysql |awk '{print $1}')
docker rm $(docker ps -q -f status=exited)
docker rmi docker.io/klc407073648/docker-mysql:v1.0

dos2unix *.sh
chmod 777 *.sh

docker build -t docker.io/klc407073648/docker-mysql:v1.0 .

docker run -it -d -p 3307:3306 --name docker-mysql docker.io/klc407073648/docker-mysql:v1.0