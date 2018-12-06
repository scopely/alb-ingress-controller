#!/usr/bin/env bash

set -ex

docker login -u ${JFROG_USER} -p${JFROG_PASS} https://${DOCKER_REPO}

GIT_HASH=$(git rev-parse HEAD)
SUFFIX=""

if [ ! -z "$1" ]
  then
    SUFFIX="-$1"
fi

DOCKER_TAG=${GIT_HASH}${SUFFIX}
DOCKER_IMAGE="${DOCKER_REPO}/${REPO_NAME}/alb-ingress-controller:${DOCKER_TAG}"

docker build \
    -f Dockerfile \
    -t ${DOCKER_IMAGE} \
    .

docker push ${DOCKER_IMAGE}
