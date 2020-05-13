FROM ubuntu:bionic

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    apt clean && \
    apt update && \
    apt install jq -y && \
    apt install curl -y

RUN mkdir /var/runtime/

ADD main.sh /var/runtime/main.sh

CMD bash /var/runtime/main.sh

