#!/bin/bash
set -ex
sudo service docker stop
sudo apt-get update
sudo apt-get -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::="--force-confnew" install docker-engine
REPO="${TRAVIS_REPO_SLUG}"
REPO="alces-software/packager-base"
docker build --build-arg treeish=${TRAVIS_COMMIT} --build-arg repo_slug="${REPO}" \
       -t "alces/packages-${TRAVIS_COMMIT}-${cw_DIST}-${cw_VERSION}" \
       ".travis/${cw_DIST}-${cw_VERSION}"
