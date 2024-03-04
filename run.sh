#!/bin/bash
TAG_VERSION=`git rev-parse --short HEAD`
echo $TAG_VERSION
sed -i s/tag/$TAG_VERSION/g docker-compose.yaml
docker build -t project-soc:$TAG_VERSION .
