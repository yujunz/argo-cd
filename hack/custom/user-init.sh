#!/bin/bash
set -eux -o pipefail

export XDG_CONFIG_HOME=/home/argocd/.config

helm2 init --client-only && \
  helm2 plugin install https://github.com/futuresimple/helm-secrets --version 2.0.2 && \
  helm2 plugin install https://github.com/hypnoglow/helm-s3.git --version 0.8.0 && \
  helm2 plugin install https://github.com/yujunz/helm-tiller
