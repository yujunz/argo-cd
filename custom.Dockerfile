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

ENV SOPS_VERSION=3.4.0
RUN curl -o /usr/local/bin/sops -L https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux && \
  chmod +x /usr/local/bin/sops

ENV HELMFILE_VERSION=v0.90.8
RUN curl -o /usr/local/bin/helmfile -L https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 && \
  chmod +x /usr/local/bin/helmfile

USER argocd

ENV XDG_CONFIG_HOME=/home/argocd/.config

COPY --from=builder /go/bin/go-getter /usr/local/bin/

RUN PLUGIN_GO_GETTER=plugin/someteam.example.com/v1/gogetter/GoGetter && \
  curl --create-dirs --show-error --silent --location --output ${XDG_CONFIG_HOME}/kustomize/${PLUGIN_GO_GETTER} \
  https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/${PLUGIN_GO_GETTER} && \
  chmod +x ${XDG_CONFIG_HOME}/kustomize/${PLUGIN_GO_GETTER}

RUN helm init --client-only && \
  helm plugin install https://github.com/futuresimple/helm-secrets --version 2.0.2 && \
  helm plugin install https://github.com/hypnoglow/helm-s3.git --version 0.8.0 && \
  # helm-tiller plugin requires pkill (installed in procps)
  helm plugin install https://github.com/rimusz/helm-tiller --version 0.8.3
