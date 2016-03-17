#!/bin/bash
export ARTIFACTS_REGION='eu-west-1'
artifacts upload \
	  --permissions=public_read \
	  --target-paths 'gridware/$dist' \
	  --working-dir "$HOME/build" \
	  .
