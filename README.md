# AWS ECS IP Port Tweezer

## Introduction

容器对进程的网络进行隔离，容器内的程序只能知晓自己所在容器内的网络 IP 和 PORT，报告给注册中心的 IP 和 PORT 即是错误的、无法通达的值，必须要使用伪端口机制，更改报告的 IP 和 PORT。

放在 AWS ECS 的 Docker 容器服务中的微服务程序，如果有注册中心机制，则需要报告容器 Task 桥接在 EC2 宿主机上的端口，我们通过 AWS ECS 服务和 EC2 服务提供的各一个 API 地址，配合一定的解析操作，即可拿到容器所使用宿主机的PORT 和宿主机在 VPC 子网内的 IP。

## Links

参考链接 01：https://medium.com/@pedrojuarez/ec2-ecs-instance-metadata-2939d7a6f2ce

参考链接 02：https://github.com/RetailMeNotSandbox/ecs-selenium/blob/master/docker/common/ecs-get-port-mapping.py

参考链接 03：https://gist.github.com/chris-smith-zocdoc/126db78651046c67ac66dbd87393b1dc