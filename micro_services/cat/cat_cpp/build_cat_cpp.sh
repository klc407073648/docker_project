#/bin/bash
docker rm $(docker ps -q -f status=exited)
docker rmi docker.io/klc407073648/stibel_cat_cpp:v1.0

dos2unix *.sh
chmod 777 *.sh

docker build -t docker.io/klc407073648/stibel_cat_cpp:v1.0 .
