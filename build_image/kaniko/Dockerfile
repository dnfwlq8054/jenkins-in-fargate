Label "https://discuss.circleci.com/t/how-to-build-and-push-docker-images-with-kaniko/44923"

FROM gcr.io/kaniko-project/executor:v1.9.2-slim as kanikosrc

# 기본 이미지 선택
FROM jenkins/inbound-agent:latest

ENV SSL_CERT_DIR=/usr/local/bin/ssl/certs
ENV PATH=/usr/local/bin:/kaniko:$PATH

COPY --from=kanikosrc /kaniko /usr/local/bin
COPY --from=kanikosrc /etc/nsswitch.conf /etc/nsswitch.conf
COPY --from=kanikosrc /kaniko/executor /kaniko/executor
COPY --from=kanikosrc /kaniko/ssl/certs/ /kaniko/ssl/certs/
