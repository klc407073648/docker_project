#/bin/bash
docker stop $(docker ps |grep angular |awk '{print $1}')
docker rm $(docker ps -q -f status=exited)
docker rmi docker.io/klc407073648/docker-angular:v1.0

dos2unix *.sh
chmod 777 *.sh

docker build -t docker.io/klc407073648/docker-angular:v1.0 .

docker run -it -d -p 4300:4300 --name docker-angular docker.io/klc407073648/docker-angular:v1.0