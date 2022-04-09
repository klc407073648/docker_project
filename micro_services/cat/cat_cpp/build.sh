 docker run -it -d --name cat_client_cplusplus_1 docker.io/klc407073648/centos_build_lib:v3.0

docker cp /home/cat/cat-master.zip cat_client_cplusplus_1:/home
docker exec -it cat_client_cplusplus_1 bash
cd /home/
unzip cat-master.zip


cd ./cat-master/lib/cpp/
mkdir cmake
cd cmake/
cmake ..
make



mkdir -p /home/cat/mycat-client
cd /home/cat/mycat-client
mkdir -p {include/cat,libs,src}

cp /home/cat-master/lib/cpp/include/client.hpp include/cat
cp /home/cat-master/lib/cpp/cmake/libcatclient.so libs


cd ./src
vi main.cpp
vi Makefile

make clean && make

export LD_LIBRARY_PATH=/home/cat/mycat-client/libs

mkdir -p /data/appdatas/cat/
cd /data/appdatas/cat/
vi client.xml

cd -
./catcpp