FROM python:3.10 as pythonsrc

# 기본 이미지 선택
FROM jenkins/inbound-agent:latest

COPY --from=pythonsrc /usr/local/bin/python3.10 /usr/local/bin/python3.10
COPY --from=pythonsrc /usr/bin/python3.9 /usr/bin/python3.9
COPY --from=pythonsrc /usr/share/python3 /usr/share/python3
COPY --from=pythonsrc /usr/local/lib /usr/local/lib

USER root

RUN ln -sf /usr/local/bin/python3.10 /usr/local/bin/python && \
    ln -sf /usr/local/bin/python3.10 /usr/local/bin/python3 && \
    ln -sf /usr/local/bin/python3.9 /usr/bin/python3

RUN apt-get update && \
    apt-get install -y unzip --no-install-recommends && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    rm -rf awscliv2.zip && \
    ./aws/install

USER jenkins
