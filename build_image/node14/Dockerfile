# 베이스 이미지 설정
FROM node:14-slim

# 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless git curl

# Jenkins inbound-agent 다운로드
ARG AGENT_VERSION=4.11
ARG AGENT_SHA=3df0b8474dbd27c977e9d7ffcc2aa8b8e76f51d1
RUN curl -fsSL https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$AGENT_VERSION/remoting-$AGENT_VERSION.jar -o agent.jar && \
    echo "$AGENT_SHA  agent.jar" | sha1sum -c -

# Jenkins 환경 변수 설정
ENV JENKINS_AGENT_HOME=/home/jenkins
RUN useradd -d $JENKINS_AGENT_HOME -u 1000 -m -s /bin/bash jenkins
USER jenkins

# 작업 디렉토리 설정
WORKDIR /home/jenkins/agent

# Jenkins inbound-agent 실행
ENTRYPOINT ["java", "-jar", "agent.jar"]
