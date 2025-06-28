#!/bin/sh

rm -rf "${ENVIRONMENT_DIR}/tmp"
mkdir -p "${ENVIRONMENT_DIR}/tmp/bin"
cp -R "${PROJECT_DIR}/bin/git-chord" "${ENVIRONMENT_DIR}/tmp/bin/git-chord"
cp -R "$TESTS_DIR" "${ENVIRONMENT_DIR}/tmp/home"
imageName="${ENVIRONMENT_NAME}-tmp"
docker build -t "$imageName" "$ENVIRONMENT_DIR" && docker run --rm "$imageName" && docker rmi "$imageName"
rm -rf "${ENVIRONMENT_DIR}/tmp"
 
