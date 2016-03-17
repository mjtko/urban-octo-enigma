#!/bin/bash
set -x
if [ "$TRAVIS_BRANCH" == "master" -a "$TRAVIS_PULL_REQUEST" == "false" ]; then
    env | grep ARTIFACTS
    export ARTIFACTS_REGION='eu-west-1'
    artifacts -f multiline upload \
	      --permissions=public-read \
	      --target-paths 'gridware' \
	      --working-dir "$HOME" \
	      '$dist'/*.tar.gz
fi
