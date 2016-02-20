#!/bin/bash
set -o errexit

if [[ -z $TRAVIS ]]; then
	readonly SMALLTALK_CI_HOME="smalltalkCI-master"
	readonly SMALLTALK_CI_BUILD="$SMALLTALK_CI_HOME/_builds/$(ls smalltalkCI-master/_builds | sort -n | head -n 1)"
	readonly SMALLTALK_CI_IMAGE="$SMALLTALK_CI_BUILD/TravisCI.image"
	readonly SMALLTALK_CI_CHANGES="$SMALLTALK_CI_BUILD/TravisCI.changes"
	readonly SMALLTALK_CI_VM=$SMALLTALK_CI_HOME/_cache/vms/Pharo-5.0/pharo
	readonly SMALLTALK_CI_VMS=$SMALLTALK_CI_HOME/_cache/vms
	readonly TRAVIS_BUILD_NUMBER=20
	readonly TRAVIS_BRANCH=master
	readonly TRAVIS_BUILD_DIR=.
	readonly TRAVIS=true
fi

source "$SMALLTALK_CI_HOME/helpers.sh"

readonly DEPLOY_NAME="dynacase"
readonly DEPLOY_DIR="$SMALLTALK_CI_BUILD/deploy/$DEPLOY_NAME"
readonly SSH_IDENTITY=.ssh/id_dynacase_travis
readonly DEPLOY_MACHINE="dynacase@ccmi.fit.cvut.cz"
readonly DEPLOY_TARGET_DIR="~/www/builds/all-in-one"
readonly DEPLOY_TARGET="$DEPLOY_MACHINE:$DEPLOY_TARGET_DIR"

prepare_deploy() {
	if [[ ! -d $DEPLOY_DIR ]]; then
		mkdir -p "$DEPLOY_DIR"
	fi
	cp $TRAVIS_BUILD_DIR/scripts/README.txt $DEPLOY_DIR
	cp $TRAVIS_BUILD_DIR/scripts/dynacase.sh $DEPLOY_DIR
	cp $TRAVIS_BUILD_DIR/scripts/DynaCASE.exe $DEPLOY_DIR
}

copy_image() {
	cp "$SMALLTALK_CI_IMAGE" "$DEPLOY_DIR/$DEPLOY_NAME.image"
	cp "$SMALLTALK_CI_CHANGES" "$DEPLOY_DIR/$DEPLOY_NAME.changes"
}

run_in_image() {
	local cmd=$1
	print_info "$cmd"
	timer_start
	$SMALLTALK_CI_VM --nodisplay $DEPLOY_DIR/$DEPLOY_NAME.image eval --save "$cmd"
	timer_finish
}

postprocess_image() {
	# this is mainly to drive the overall size down
	run_in_image 'Smalltalk cleanUp: true'
	#run_in_image 'PharoChangesCondenser condense'
	rm -f $DEPLOY_DIR/$DEPLOY_NAME.changes.bak
}

deploy() {
	prepare_deploy
	copy_image
	postprocess_image

	cd $DEPLOY_DIR/..
	local build_zip="${DEPLOY_NAME}-image-${TRAVIS_BUILD_NUMBER}.zip"
	zip -qr "$build_zip" "$DEPLOY_NAME"
	scp -rp "$build_zip" "$DEPLOY_TARGET"
	ssh "$DEPLOY_MACHINE" "~/bundler/post-deploy.sh ${TRAVIS_BUILD_NUMBER}"
}

main() {
	local exit_status=0
	travis_fold start deploy "Deployment"
	deploy || exit_status=$?
	travis_fold end deploy
	if [[ "$exit_status" -ne 0 ]]; then
		print_error "Failed to deploy build."
		exit $exit_status
	fi
	print_success "Build ${DEPLOY_NAME}-${TRAVIS_BUILD_NUMBER} deployed."
}

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
	main
fi
