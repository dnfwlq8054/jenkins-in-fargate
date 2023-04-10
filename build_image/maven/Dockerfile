FROM maven as mavensrc

# 기본 이미지 선택
FROM jenkins/inbound-agent:latest

COPY --from=mavensrc /usr/share/maven /usr/share/maven

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "${USER_HOME_DIR}/.m2"
ENV PATH "${PATH}:${MAVEN_HOME}/bin"
