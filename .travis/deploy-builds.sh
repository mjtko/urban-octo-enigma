#!/bin/bash
if [ "$TRAVIS_BRANCH" == "master" -a "$TRAVIS_PULL_REQUEST" == "false" ]; then
    export ARTIFACTS_REGION='eu-west-1'
    artifacts -f multiline upload \
	      --permissions=public-read \
	      --target-paths 'gridware' \
	      --working-dir "$HOME" \
	      '$dist'
fi
