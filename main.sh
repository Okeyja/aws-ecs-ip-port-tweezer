#!/bin/bash

# 伪端口样例脚本
# 作者 Okeyja https://github.com/okeyja
#
# 容器对进程的网络进行隔离，容器内的程序只能知晓自己所在容器内的网络 IP 和 PORT，报告给注册中心
# 的 IP 和 PORT 即是错误的、无法通达的值，必须要使用伪端口机制，更改报告的 IP 和 PORT。
#
# 放在 AWS ECS 的 Docker 容器服务中的微服务程序，如果有注册中心机制，则需要报告容器 Task 桥接
# 在 EC2 宿主机上的端口，我们通过 AWS ECS 服务和 EC2 服务提供的各一个 API 地址，配合一定的解析
# 操作，即可拿到容器所使用宿主机的 PORT 和宿主机在 VPC 子网内的 IP。
#
# 参考链接 01：https://medium.com/@pedrojuarez/ec2-ecs-instance-metadata-2939d7a6f2ce
# 参考链接 02：https://github.com/RetailMeNotSandbox/ecs-selenium/blob/master/docker/common/ecs-get-port-mapping.py
# 参考链接 03：https://gist.github.com/chris-smith-zocdoc/126db78651046c67ac66dbd87393b1dc

# Meta Data URL
meta_url=http://172.17.0.1:51678/v1
ec2_meta_url=http://169.254.169.254/latest/meta-data

# docker_id
# 结果：/ecs/任务ID/容器运行时ID
# 样例：/ecs/e6120699-589e-4f22-bfa8-6c7afd4d7e66/d812fa40f21940323169bc8def046309ff393cd565a6f9991d0b1194e5063442
echo "=========================="
echo "FROM /proc/1/cpuset"
full_id=$(cat /proc/1/cpuset)
array=(${full_id//\// })  
docker_id=${array[2]}
echo $docker_id
echo ""

# meta_data
# 样例：
# {
# 	"Cluster": "ecs-meta-sample-cluster-2",
# 	"ContainerInstanceArn": "arn:aws-cn:ecs:cn-north-1:123456789012:container-instance/342149db-f862-4428-9db9-9998d6e51ada",
# 	"Version": "Amazon ECS Agent - v1.39.0 (61d418ea)"
# }
echo "=========================="
echo "FROM" $meta_url/metadata
meta_data=$(curl $meta_url/metadata)
echo $meta_data
echo ""

# ecs_local_task
# 样例：
# {
# 	"Arn": "arn:aws-cn:ecs:cn-north-1:123456789012:task/b94b0af7-1150-40e7-b639-c08e4fe342ba",
# 	"DesiredStatus": "RUNNING",
# 	"KnownStatus": "RUNNING",
# 	"Family": "ecs-meta-sample-02",
# 	"Version": "1",
# 	"Containers": [{
# 		"DockerId": "d812fa40f21940323169bc8def046309ff393cd565a6f9991d0b1194e5063442",
# 		"DockerName": "ecs-ecs-meta-sample-02-1-ecs-meta-sample-88efec91c3b598c5a301",
# 		"Name": "ecs-meta-sample",
# 		"Ports": [{
# 			"ContainerPort": 8080,
# 			"Protocol": "tcp",
# 			"HostPort": 8080
# 		}]
# 	}]
# }
echo "=========================="
echo "FROM" $meta_url/tasks?dockerid=$docker_id
ecs_local_task=$(curl $meta_url/tasks?dockerid=$docker_id)
echo $ecs_local_task
echo ""


# 得到 PORT，注意这里只支持添加一个 Container，且只有一个暴露的端口在 Task Definition 上
echo "=========================="
echo "Port"
port=$(echo $ecs_local_task | jq .Containers[0].Ports[0].HostPort)
echo $port
echo ""

# 得到 IP
ip=$(curl $ec2_meta_url/local-ipv4 2>/dev/null)
echo $ip


# 死循环防止进程退出
while [ true ]
do :
done