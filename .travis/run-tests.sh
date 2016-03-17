#!/bin/bash
packages=$(git diff --name-only ${TRAVIS_COMMIT_RANGE} | grep metadata.yml | cut -f1-3 -d'/')
if [ "${packages}" ]; then
    echo "Changed packages within ${TRAVIS_COMMIT_RANGE}: ${packages}"
    failed=()
    for a in ${packages}; do
	docker run alces/packages-${TRAVIS_COMMIT} /bin/bash -l -c "alces gridware install ${a}"
	if [ $? -gt 0 ]; then
	    failed+=(${a})
	fi
	output="$HOME/build/${TRAVIS_JOB_NUMBER}/$(echo "$a" | tr '/' '-')"
	container=$(docker ps -alq)
	mkdir -p "${output}"
	docker cp ${container}:/var/log/gridware "${output}"
    done
    if [ "${failed[*]}" ]; then
	echo "Failed to build: ${failed[*]}"
	exit 1
    fi
else
    echo "No package changes detected within ${TRAVIS_COMMIT_RANGE}"
fi
