# Istio

istio是kubernetes好帮手，可以帮kubernetes实现服务治理功能。

kubernetes可以帮助istio实现

* 数据平面
  * 利用一个pod可以运行多个容器的特点，实现数据平面功能
* 统一服务发现
  * Ingress是k8s的资源，外部请求通过Ingress, 转发给Pod(Ingress里配置域名的映射)
  *  配置提供外部可访问的 URL、负载均衡、SSL、基于名称的虚拟主机等。
* 基于CRD规则扩展自定义资源
  * istio通过CRD规则自定义资源，而资源数据通过apiserver保存到etcd里面

https://www.servicemesher.com/istio-handbook/concepts/microservices-in-post-kubernetes-era.html

https://jimmysong.io/kubernetes-handbook/concepts/crd.html



k8s 安装

https://blog.csdn.net/weixin_47678667/article/details/121680938



istio 安装时：

首先在msater节点下安装，不要加入node，这样能直接安装成功：

不然，安装一直报错：

```
cd 
vi /etc/profile
加入 export PATH=$PATH:/home/istio/istio-1.5.0/bin
source /etc/profile


[root@iZuf61kbf845xt6tz10abgZ ~]# istioctl manifest apply --set profile=demo
Detected that your cluster does not support third party JWT authentication. Falling back to less secure first party JWT. See https://istio.io/docs/ops/best-practices/security/#configure-third-party-service-account-tokens for details.
- Applying manifest for component Base...
✔ Finished applying manifest for component Base.
- Applying manifest for component Pilot...
✔ Finished applying manifest for component Pilot.
- Applying manifest for component IngressGateways...
- Applying manifest for component EgressGateways...
- Applying manifest for component AddonComponents...
✔ Finished applying manifest for component EgressGateways.
2022-04-13T23:31:06.344536Z     error   installer       error running kubectl: exit status 1
✘ Finished applying manifest for component AddonComponents.
2022-04-13T23:31:34.877288Z     error   installer       error running kubectl: exit status 1
✘ Finished applying manifest for component IngressGateways.

失败问题：
Events:
  Type     Reason     Age                    From                     Message
  ----     ------     ----                   ----                     -------
  Normal   Scheduled  4m26s                  default-scheduler        Successfully assigned istio-system/istio-tracing-c7b59f68f-dzrz6 to vm-16-6-centos
  Normal   Killing    3m16s (x2 over 3m56s)  kubelet, vm-16-6-centos  Container jaeger failed liveness probe, will be restarted
  Warning  Unhealthy  3m13s (x7 over 4m23s)  kubelet, vm-16-6-centos  Readiness probe failed: HTTP probe failed with statuscode: 503
  Normal   Pulled     3m3s (x3 over 4m25s)   kubelet, vm-16-6-centos  Container image "docker.io/jaegertracing/all-in-one:1.16" already present on machine
  Normal   Created    3m3s (x3 over 4m25s)   kubelet, vm-16-6-centos  Created container jaeger
  Normal   Started    3m3s (x3 over 4m24s)   kubelet, vm-16-6-centos  Started container jaeger
  Warning  Unhealthy  2m56s (x7 over 4m16s)  kubelet, vm-16-6-centos  Liveness probe failed: HTTP probe failed with statuscode: 503
[root@iZuf61kbf845xt6tz10abgZ ~]# kubectl  logs -f --tail 200 istio-tracing-c7b59f68f-dzrz6 -n istio-system
Error from server: Get https://10.0.16.6:10250/containerLogs/istio-system/istio-tracing-c7b59f68f-dzrz6/jaeger?follow=true&tailLines=200: dial tcp 10.0.16.6:10250: i/o timeout
```

正确做法：

```
清理从节点，调整mater节点能部署pod
kubectl delete node  vm-16-6-centos
kubectl get no -o yaml | grep taint -A 5
kubectl taint nodes --all node-role.kubernetes.io/master
istioctl manifest apply --set profile=demo

执行后发现容器正常一段时间后又异常了,查看污点和容忍度，发现虚机的硬盘不足：
[root@iZuf61kbf845xt6tz10abgZ ~]# kubectl get no -o yaml | grep taint -A 5
    taints:
    - effect: NoSchedule
      key: node.kubernetes.io/disk-pressure
      timeAdded: "2022-04-16T00:56:21Z"
  status:
    addresses:
    
清理后，重新执行就正常了：    
[root@iZuf61kbf845xt6tz10abgZ ~]# kubectl get pods -n istio-system
NAME                                   READY   STATUS    RESTARTS   AGE
grafana-78bc994d79-p5g42               1/1     Running   0          9m56s
istio-egressgateway-7c9f7d5bd6-h5swx   1/1     Running   0          10m
istio-ingressgateway-f9b47d445-n7crd   1/1     Running   0          10m
istio-tracing-c7b59f68f-kbfsk          1/1     Running   0          9m56s
istiod-5745bd5f6b-2ptpt                1/1     Running   0          10m
kiali-57fb5bb5c6-26wq8                 1/1     Running   0          9m55s
prometheus-78f785fc6b-nwpm8            2/2     Running   0          9m55s
```

