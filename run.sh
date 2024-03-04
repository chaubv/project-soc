#!/bin/bash
TAG=`git rev-parse --short HEAD`
echo $TAG
docker build -t project-soc:$TAG .
