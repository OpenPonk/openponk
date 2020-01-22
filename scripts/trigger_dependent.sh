#!/bin/bash

set -euo pipefail

trigger() {
	echo "Triggering build of ${1}"
	body='{"request":{"branch":"master"}}'
	curl -s -X POST \
	   -H "Content-Type: application/json" \
	   -H "Accept: application/json" \
	   -H "Travis-API-Version: 3" \
	   -H "Authorization: token ${TRIGGER_TOKEN}" \
	   -d "$body" \
	   "https://api.travis-ci.com/repo/OpenPonk%2F${1}/requests"
}

if [[ "$TRAVIS_EVENT_TYPE" == "push" && "$TRAVIS_BRANCH" == "master" ]]; then
	for repository in "$@"; do
		trigger $repository
	done
else
	echo "Will not trigger dependent builds because TRAVIS_EVENT_TYPE is $TRAVIS_EVENT_TYPE and TRAVIS_BRANCH is $TRAVIS_BRANCH"
fi
