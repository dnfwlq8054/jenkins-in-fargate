FROM hashicorp/terraform:1.4.4 as terraformsrc

FROM jenkins/inbound-agent

COPY --from terraformsrc /bin/terraform /bin/terraform

ENV BIN_NAME=terraform
