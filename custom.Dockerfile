####################################################################################################
# argocd with custom tools
####################################################################################################
FROM golang:1.13 as builder
# Workaround for https://github.com/hashicorp/go-getter/issues/223
RUN go get -v github.com/cheggaaa/pb
RUN go get -v github.com/hashicorp/go-getter
RUN go install github.com/hashicorp/go-getter/cmd/go-getter

FROM argoproj/argocd

USER root

RUN apt-get update && \
  apt-get install -y curl awscli gnupg procps && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN SOPS_VERSION=3.4.0 curl -o /usr/local/bin/sops -L https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux && \
  chmod +x /usr/local/bin/sops

RUN HELMFILE_VERSION=v0.134.1 curl -o /usr/local/bin/helmfile -L https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 && \
  chmod +x /usr/local/bin/helmfile

USER argocd

ENV XDG_CONFIG_HOME=/home/argocd/.config

RUN helm2 init --client-only && \
  helm2 plugin install https://github.com/futuresimple/helm-secrets --version 2.0.2 && \
  helm2 plugin install https://github.com/hypnoglow/helm-s3.git --version 0.8.0 && \
  helm2 plugin install https://github.com/yujunz/helm-tiller
