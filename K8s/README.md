# Kubernetes容器运行系统管理
Kubernetes也称为 K8s，是用于自动部署、扩缩和管理容器化应用程序的开源系统。Kubernetes解决了手动部署多个容器到多台机器上并监测管理这些容器的状态的问题，Kubernetes提供了一个平台比较高层次的抽象化去自动化操作与管理容器。Kubernetes 容器编排已越来越被大家关注，然而学习 Kubernetes 的门槛却依然很高，主要体现在这几个方面：1.集群的安装复杂。2.Kubernetes相较于容器，引入了许多新的概念。3.需要手工编写 YAML 文件。4.没有好的参考案例可以遵循。本项目设计了一个Kubernetes容器运行系统管理，给用户提供Kubernetes Web端的图形化操作，方便用户对Kubernetes进行管理。项目中使用Go语言实现了Web服务器，通过Web服务进行开发，当Web服务器接收到特定的HTTP请求后在后端操作Kubernetes在指定的虚拟机上创建指定的容器。在项目中通过Go语言实现了高并发，在高并发条件下有着更好的性能，完美契合当下高并发的互联网生态。同时项目封装比较优雅，API友好，源码注释比较明确，具有快速灵活，容错方便。
## 运行方式
使用go语言运行在Kubernetes的master所在的服务器上
```bash
go build main.go
./main
```
## 实现的接口
### `/getnodes`
查询Kubernetes容器节点名称
### `/createpod`
通过POST请求传参，其中name为容器名称，image为镜像名称，node为节点名称
```text
name=mynginx&image=nginx&node=minikube-m03
```
### `/getpods`
查询已创建的容器以及容器所在的节点名称