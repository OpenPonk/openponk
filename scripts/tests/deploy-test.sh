#!/usr/bin/env bats

readonly ARTIFACT_DIR="openponk-image-0"

@test "build has been deployed" {
	mkdir -p $ARTIFACT_DIR
	echo "image" > $ARTIFACT_DIR/openponk.image
	echo "changes" > $ARTIFACT_DIR/openponk.changes
	export TRAVIS_BUILD_NUMBER=0
	export TRAVIS_BRANCH=master
	export ARTIFACT_DIR
	run ../deploy.sh deploy-build
	[ $status -eq 0 ]
	echo ">$output<"
	[ "${lines[0]}" = "deploy test ok" ]
}

teardown() {
	rm -rf $ARTIFACT_DIR
	rm $ARTIFACT_DIR.zip
}
