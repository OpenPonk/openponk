#!/bin/bash
set -o errexit

source "$SMALLTALK_CI_HOME/helpers.sh"

### TEMP

if [[ -z $TRAVIS ]]; then
	readonly SMALLTALK_CI_BUILD="smalltalkCI-master/_builds/$(ls smalltalkCI-master/_builds | sort -n | head -n 1)"
	readonly SMALLTALK_CI_IMAGE="$SMALLTALK_CI_BUILD/TravisCI.image"
	readonly SMALLTALK_CI_CHANGES="$SMALLTALK_CI_BUILD/TravisCI.changes"
	readonly SMALLTALK_CI_VM=smalltalkCI-master/_cache/vms/Pharo-5.0/pharo
	readonly SMALLTALK_CI_VMS=smalltalkCI-master/_cache/vms
	readonly TRAVIS_BUILD_NUMBER=20
	readonly TRAVIS_BRANCH=master
	readonly TRAVIS=true
fi

###


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
	cp $TRAVIS_BUILD_DIR/scripts/run.sh $DEPLOY_DIR/run.sh
}

prepare_image() {
	cp "$SMALLTALK_CI_IMAGE" "$DEPLOY_DIR/$DEPLOY_NAME.image"
	cp "$SMALLTALK_CI_CHANGES" "$DEPLOY_DIR/$DEPLOY_NAME.changes"
}

download-vm() {
	local os=$1
	local vm_dir=$2
	local url="http://files.pharo.org/get-files/50/pharo-$os-stable.zip"
	mkdir -p $vm_dir
	curl --silent --location --compressed --output $vm_dir/vm.zip $url
	unzip -q $vm_dir/vm.zip -d $vm_dir
	rm -f $vm_dir/vm.zip
}

prepare_vms() {
	mkdir -p $DEPLOY_DIR/vms/linux
	# no need to download linux vm again
	cp -rv $SMALLTALK_CI_VMS/* $DEPLOY_DIR/vms/linux
	download-vm mac $DEPLOY_DIR/vms/mac
	download-vm win $DEPLOY_DIR/vms/win

}

deploy() {
	prepare_deploy
	prepare_image
	prepare_vms

	cd $DEPLOY_DIR/..
	local build_zip="${DEPLOY_NAME}-${TRAVIS_BUILD_NUMBER}.zip"
	zip -r "$build_zip" "$DEPLOY_NAME"
	scp -rp "$build_zip" "$DEPLOY_TARGET"
	ssh "$DEPLOY_MACHINE" "cp ${DEPLOY_TARGET_DIR}/${build_zip} ${DEPLOY_TARGET_DIR}/latest.zip"
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
