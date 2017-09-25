#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

#source "$SMALLTALK_CI_HOME/helpers.sh"

# wherever you'll be ssh-ing into user@machine
readonly TARGET_MACHINE="openponk@ccmi.fit.cvut.cz"
# target dir on the target machine
readonly TARGET_DIR="~/builds/openponk"

# customize the name of the Pharo image you will be deploying
readonly PROJECT_NAME="openponk"
# customize the name of the build folder, this is expected to be in an env var
# readonly ARTIFACT_DIR="${PROJECT_NAME}-image-${TRAVIS_BUILD_NUMBER}"

# zip the image, and send upload to the server
deploy-scp() {
	local directory=$1
	local build_zip="${directory}.zip"
	zip -qr "$build_zip" "$directory"
	scp -rp "$build_zip" "$TARGET_MACHINE:$TARGET_DIR"
	# I have a server-side post-processing script that bundles VMs into the build
	ssh "$TARGET_MACHINE" "~/scripts/process-core-build.sh ${TRAVIS_BUILD_NUMBER}"
}

main() {
	deploy-scp ${ARTIFACT_DIR}
	echo "Build ${ARTIFACT_DIR} deployed."
}

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
	main
fi
