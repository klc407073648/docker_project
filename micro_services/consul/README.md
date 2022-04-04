# 使用

server.json 为consul的服务端配置
client.json 为consul的客户端配置

需要配置相同的数据中心 "datacenter": "datacenter1"

consul_nodes下可用，需要为server和client创建网络平面

# 待实现的idea

- [ ] ACL鉴权————consul服务端和客户端通信需要鉴权
- [ ] 需要保证server和client的网络可以访问，再用一个段下
- [ ] xxxx
