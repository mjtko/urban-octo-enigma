#!/bin/bash
if [ "$TRAVIS_BRANCH" == "master" -a "$TRAVIS_PULL_REQUEST" == "false" ]; then
    export ARTIFACTS_REGION='eu-west-1'
    artifacts upload \
	      --permissions=public_read \
	      --target-paths 'gridware/$dist' \
	      --working-dir "$HOME/build" \
	      .
fi
