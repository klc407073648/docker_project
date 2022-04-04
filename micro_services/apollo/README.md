# README

使用方法：

1. 构建mysql数据库，创建apollo所需数据库内容————docker_project/mysql
2. 构建apollo的服务所需内容，包括configservice,adminservice,portal————docker_project/micro_services/apollo/docker/apollo
3. 构建apollo_go客户端，修改main.go的内容(AppID,NamespaceName)————docker_project/micro_services/apollo/apollo_go/build_apollo_go