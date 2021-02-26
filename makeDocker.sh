#!/bin/bash

# Mainly taken from the `makeDocker.sh` file from version 2.0.3
# https://github.com/UCREL/science-parse/blob/b89f687eb7d031df9b8b746da92b7fdd9b69a84d/makeDocker.sh

VERSION=`cat version.sbt | sed -Ee "s/version in [A-Za-z]+ := \"([0-9.]+(-SNAPSHOT)?)\"/\1/"`
sbt server/assembly
DOCKER_BUILDKIT=1 docker build --progress=plain -t ucrel/ucrel-science-parse-builder:$VERSION \
                               --build-arg OPENJDK_TAG=8u282 -f build.Dockerfile .
DOCKER_BUILDKIT=1 docker build --progress=plain -t ucrel/ucrel-science-parse:$VERSION \
                               --build-arg OPENJDK_TAG=8u282 --build-arg JAVA_MEMORY=8 \
                               --build-arg SP_VERSION=$VERSION .

