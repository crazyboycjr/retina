#!/usr/bin/env bash

function get_makefile_variable() {
  make --eval='print-%:; @echo "$($*)"' print-$1
}

# Push image to remote
IMAGE_REGISTRY=`get_makefile_variable IMAGE_REGISTRY`
TAG=`get_makefile_variable RETINA_PLATFORM_TAG`
RETINA_IMAGE=`get_makefile_variable RETINA_IMAGE`
RETINA_INIT_IMAGE=`get_makefile_variable RETINA_INIT_IMAGE`
RETINA_OPERATOR_IMAGE=`get_makefile_variable RETINA_OPERATOR_IMAGE`

function save_docker_image() {
  IMAGE=$1
  OUT=$2
  # docker images --format "{{json .Repository}}" --format "{{json .Tag}}" --format "{{json .ID}}"
  IMAGE_ID=`docker image ls $IMAGE --format "{{.ID}}"`
  OUT=${OUT%".tar"}-$IMAGE_ID.tar
  echo "Saving $IMAGE to $OUT"
  [[ ! -f $OUT ]] && docker save "$IMAGE" | pv -s $(docker image inspect "$IMAGE" --format='{{.Size}}') > "$OUT"
}

save_docker_image "$IMAGE_REGISTRY/$RETINA_INIT_IMAGE:$TAG" retina-init.tar
save_docker_image "$IMAGE_REGISTRY/$RETINA_IMAGE:$TAG" retina-agent.tar
save_docker_image "$IMAGE_REGISTRY/$RETINA_OPERATOR_IMAGE:$TAG" retina-operator.tar

# sudo docker compose up -d retina
# sudo docker compose up -d retina-agent