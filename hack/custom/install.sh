#!/bin/bash
set -eux -o pipefail

apt-get update && \
  apt-get install -y curl awscli gnupg procps && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

export CURL_ARGS="-sSL --fail"
export BIN=/usr/local/bin

export SOPS_VERSION=v3.6.1

curl ${CURL_ARGS} -o ${BIN}/sops https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux
chmod +x ${BIN}/sops

export HELMFILE_VERSION=0.138.4-3-g90de61a
export HELMFILE_RELEASE=https://github.com/yujunz/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_Linux_x86_64.tar.gz
curl ${CURL_ARGS} ${HELMFILE_RELEASE} | tar zxf - -C ${BIN} helmfile
