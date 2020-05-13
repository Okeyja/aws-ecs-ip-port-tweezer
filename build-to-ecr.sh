#!/bin/bash
TAG=123456789012.dkr.ecr.cn-north-1.amazonaws.com.cn/ecs-meta-sample:script-1.0
docker build . -t  $TAG
docker push $TAG
