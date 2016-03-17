#!/bin/bash
set -x
packages=$(git diff --name-only ${TRAVIS_COMMIT_RANGE} | grep metadata.yml | cut -f1-3 -d'/')
if [ "${packages}" ]; then
    echo "Changed packages within ${TRAVIS_COMMIT_RANGE}: ${packages}"
    failed=()
    img="alces/packages-${TRAVIS_COMMIT}-${cw_DIST}-${cw_VERSION}"
    for a in ${packages}; do
	docker tag $img $img:build
	nicename="$(echo "$a" | tr '/' '-')"
	unset ci_skip export_args export_skip install_args export_packages
	if [ -f .travis/tweaks/${nicename}.sh ]; then
	    . .travis/tweaks/${nicename}.sh
	fi
	if [ -z "$ci_skip" ]; then
	    log_output="$HOME/logs/build-${TRAVIS_BUILD_NUMBER}/${TRAVIS_JOB_NUMBER}/${nicename}"
	    build_output="$HOME"/'$dist'
	    mkdir -p "${log_output}"
	    docker run ${img}:build /bin/bash -l -c "alces gridware install ${a} ${install_args}"
	    if [ $? -gt 0 ]; then
		failed+=(${a})
	    elif [ -z "$export_skip" ]; then
		for b in ${export_packages:-${a}}; do
		    docker commit $(docker ps -alq) $img:installed
		    docker run ${img}:installed /bin/bash -l -c "alces gridware export ${export_args} ${b}"
		    if [ $? -gt 0 ]; then
			failed+=(${b})
		    fi
		done
	    fi
	    ctr=$(docker ps -alq)
	    docker cp ${ctr}:/var/log/gridware "${log_output}"
	    for b in ${export_packages:-${a}}; do
		nicename="$(echo "$b" | tr '/' '-')"
		docker cp ${ctr}:/tmp/${nicename}-${cw_DIST}.tar.gz "${build_output}"
		ls -l "${build_output}"
		pushd "${build_output}"
		pwd
		popd
	    done
	else
	    echo "Skipping blacklisted package: ${a}"
	fi
    done
    if [ "${failed[*]}" ]; then
	echo "Failed to build: ${failed[*]}"
	exit 1
    fi
else
    echo "No package changes detected within ${TRAVIS_COMMIT_RANGE}"
fi
