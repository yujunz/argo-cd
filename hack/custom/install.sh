#!/bin/bash
set -eux -o pipefail

apt-get update && \
  apt-get install -y curl awscli gnupg procps && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

export CURL_ARGS="-sSL --fail"

export SOPS_VERSION=3.4.0
export HELMFILE_VERSION=v0.134.1

curl ${CURL_ARGS} -o /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux
chmod +x /usr/local/bin/sops

curl ${CURL_ARGS} -o /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64
chmod +x /usr/local/bin/helmfile
