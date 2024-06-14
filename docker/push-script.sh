#!/bin/bash

# Definiere Variablen
DOCKER_USERNAME=your-username
IMAGE_NAME=your-image-name
TAG=latest
DOCKERFILE_PATH=../Dockerfile
BUILD_CONTEXT=../

# Baue das Docker-Image mit dem angegebenen Kontext
docker build -t $DOCKER_USERNAME/$IMAGE_NAME -f $DOCKERFILE_PATH $BUILD_CONTEXT

# Melde dich bei Docker Hub an
docker login

# Tagge das Docker-Image
docker tag $DOCKER_USERNAME/$IMAGE_NAME $DOCKER_USERNAME/$IMAGE_NAME:$TAG

# Pushe das Docker-Image zu Docker Hub
docker push $DOCKER_USERNAME/$IMAGE_NAME:$TAG
