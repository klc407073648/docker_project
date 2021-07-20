#/bin/bash
docker stop $(docker ps |grep stibel |awk '{print $1}')
docker rm $(docker ps -q -f status=exited)
docker rmi docker.io/klc407073648/docker-stibel:v1.0

dos2unix *.sh
chmod 777 *.sh

docker build -t docker.io/klc407073648/docker-stibel:v1.0 .

docker run -it -d -p 9950:9950 --name docker-stibel docker.io/klc407073648/docker-stibel:v1.0