#!/bin/bash
set -eux -o pipefail

helm2 init --client-only && \
  helm2 plugin install https://github.com/futuresimple/helm-secrets --version 2.0.2 && \
  helm2 plugin install https://github.com/hypnoglow/helm-s3.git --version 0.8.0 && \
  helm2 plugin install https://github.com/yujunz/helm-tiller

export KUSTOMIZE_PLUGIN_PATH=${XDG_CONFIG_HOME}/kustomize/plugin

export KSOPS_VERSION=2.2.2
export KSOPS_PATH=${KUSTOMIZE_PLUGIN_PATH}/viaduct.ai/v1/ksops
mkdir -p $KSOPS_PATH
curl -sSL --fail https://github.com/viaduct-ai/kustomize-sops/releases/download/v${KSOPS_VERSION}/ksops_${KSOPS_VERSION}_Linux_x86_64.tar.gz \
  | tar xzf - -C ${KSOPS_PATH} ksops
chmod +x ${KSOPS_PATH}/ksops
mkdir -p ${KSOPS_PATH}-exec
ln -s ../ksops/ksops ${KSOPS_PATH}-exec/ksops-exec
