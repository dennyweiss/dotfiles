#!/bin/bash

docker-azure-cli() {

  DOCKER_IMAGE="e-team/tooling/docker-azure-cli:2.0.67"

  docker run \
    -v ${HOME}/.azure:/root/.azure \
    -v ${HOME}/.ssh:/root/.ssh \
    -v $(pwd):/work \
    -w /work \
    -it \
    --rm \
    "${DOCKER_IMAGE}" \
    "${@}"

}

alias az="docker-azure-cli"