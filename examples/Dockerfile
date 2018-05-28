FROM debian:9
ENV TERRAFORM_ZIP=/tmp/terraform.zip
ENV TERRAFORM_VERSION=0.10.8
RUN apt-get update && apt-get install -y git python2.7 python-pip jq curl unzip openssh-client && apt-get clean && \
  pip install paramiko && \
  curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > $TERRAFORM_ZIP && \
  unzip $TERRAFORM_ZIP -d /usr/local/bin