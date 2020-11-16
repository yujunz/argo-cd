####################################################################################################
# argocd with custom tools
####################################################################################################
FROM argoproj/argocd

USER root

RUN apt-get update && \
  apt-get install -y curl awscli gnupg procps && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG SOPS_VERSION=3.4.0
ARG HELMFILE_VERSION=v0.134.1
ARG CURL_ARGS="-sSL --fail"

RUN curl ${CURL_ARGS} -o /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux && \
  chmod +x /usr/local/bin/sops

RUN curl ${CURL_ARGS} -o /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 && \
  chmod +x /usr/local/bin/helmfile

USER argocd

ENV XDG_CONFIG_HOME=/home/argocd/.config

RUN helm2 init --client-only && \
  helm2 plugin install https://github.com/futuresimple/helm-secrets --version 2.0.2 && \
  helm2 plugin install https://github.com/hypnoglow/helm-s3.git --version 0.8.0 && \
  helm2 plugin install https://github.com/yujunz/helm-tiller
