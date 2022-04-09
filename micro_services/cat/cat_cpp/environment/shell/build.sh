# 解压文件
source /etc/profile

cd /home/
unzip cat-master.zip

# 构建cat-cpp
cd /home/cat-master/lib/cpp/
mkdir cmake && cd ./cmake/
cmake ..
make

# 拷贝生成头文件和so 
cp /home/cat-master/lib/cpp/include/client.hpp /home/cat/mycat-client/include/cat
cp /home/cat-master/lib/cpp/cmake/libcatclient.so /home/cat/mycat-client/libs

# 构建cat_cpp
cd /home/cat/mycat-client/src
make clean && make