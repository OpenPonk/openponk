#!/bin/bash

# exit on first encountered error
set -o errexit

source "$SMALLTALK_CI_HOME/helpers.sh"

# wherever you'll be ssh-ing into user@machine
readonly TARGET_MACHINE="dynacase@ccmi.fit.cvut.cz"
# target dir on the target machine
readonly TARGET_DIR="~/www/builds/all-in-one"

# customize the name of the Pharo image you will be deploying
readonly PROJECT_NAME="dynacase"
# customize the name of the build folder
readonly ARTIFACT_DIR="${PROJECT_NAME}-image-${TRAVIS_BUILD_NUMBER}"

# Rename the image, zip it, and send it to a server
deploy-simple() {
	mkdir "$ARTIFACT_DIR"
	cp "$SMALLTALK_CI_IMAGE" "${ARTIFACT_DIR}/${PROJECT_NAME}.image"
	cp "$SMALLTALK_CI_CHANGES" "${ARTIFACT_DIR}/${PROJECT_NAME}.changes"

	local build_zip="${ARTIFACT_DIR}.zip"
	zip -qr "$build_zip" "$ARTIFACT_DIR"
	scp -rp "$build_zip" "$TARGET_MACHINE:$TARGET_DIR"
	# I have a server-side post-processing script that bundles VMs into the build
	ssh "$TARGET_MACHINE" "~/bundler/post-deploy.sh ${TRAVIS_BUILD_NUMBER}"
}

main() {
	deploy-simple
	echo "Build ${ARTIFACT_DIR} deployed."
}

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
	main
fi
