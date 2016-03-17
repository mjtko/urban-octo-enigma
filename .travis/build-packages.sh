#!/bin/bash
packages=$(git diff --name-only ${TRAVIS_COMMIT_RANGE} | grep metadata.yml | cut -f1-3 -d'/')
if [ "${packages}" ]; then
    echo "Changed packages within ${TRAVIS_COMMIT_RANGE}: ${packages}"
    failed=()
    img="alces/packages-${TRAVIS_COMMIT}-${cw_DIST}-${cw_VERSION}"
    for a in ${packages}; do
	nicename="$(echo "$a" | tr '/' '-')"
	if [ -f .travis/tweaks/${nicename}.sh ]; then
	    . .travis/tweaks/${nicename}.sh
	fi
	if [ -z "$ci_skip" ]; then
	    output="$HOME/build-${TRAVIS_BUILD_NUMBER}/${TRAVIS_JOB_NUMBER}/${nicename}"
	    mkdir -p "${output}"
	    docker run ${img} /bin/bash -l -c "alces gridware install ${a}"
	    if [ $? -gt 0 ]; then
		failed+=(${a})
	    else
		docker run ${img} /bin/bash -l -c "alces gridware export ${a}"
		if [ $? -gt 0 ]; then
		    failed+=(${a})
		fi
	    fi
	    container=$(docker ps -alq)
	    docker cp ${container}:/var/log/gridware "${output}"
	    docker cp ${container}:/tmp/${nicename}-${cw_DIST}.tar.gz "${output}"
	else
	    echo "Skipping blacklisted package: ${a}"
	    unset ci_skip
	fi
    done
    if [ "${failed[*]}" ]; then
	echo "Failed to build: ${failed[*]}"
	exit 1
    fi
else
    echo "No package changes detected within ${TRAVIS_COMMIT_RANGE}"
fi
