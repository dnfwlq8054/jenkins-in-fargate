FROM gcr.io/kaniko-project/executor:v1.9.2-slim as kanikosrc

# 기본 이미지 선택
FROM jenkins/inbound-agent:latest

COPY --from=kanikosrc /kaniko /usr/local/bin
ENV SSL_CERT_DIR=/usr/local/bin/ssl/certs
