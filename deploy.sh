#!/bin/bash
set -o errexit
set -v

source "$SMALLTALK_CI_HOME/helpers.sh"

### TEMP

if [[ 1 -eq 0 ]]; then
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
readonly DEPLOY_TARGET="dynacase@ccmi.fit.cvut.cz:~/www/builds/"

prepare_deploy() {
	if [[ ! -d $DEPLOY_DIR ]]; then
		mkdir -p "$DEPLOY_DIR"
	fi
	cat > "$DEPLOY_DIR/run.sh" << EOF
#!/bin/sh
readonly VM_UI="./vms/Pharo-5.0/pharo-ui"
\$VM_UI $DEPLOY_NAME.image
EOF
	chmod a+x $DEPLOY_DIR/run.sh
}

prepare_image() {
	cp "$SMALLTALK_CI_IMAGE" "$DEPLOY_DIR/$DEPLOY_NAME.image"
	cp "$SMALLTALK_CI_CHANGES" "$DEPLOY_DIR/$DEPLOY_NAME.changes"
}

prepare_vms() {
	cp -rv "$SMALLTALK_CI_VMS" "$DEPLOY_DIR"
}

deploy() {
	prepare_deploy
	prepare_image
	prepare_vms

	cd $DEPLOY_DIR/..
	local build_zip="${DEPLOY_NAME}-${TRAVIS_BUILD_NUMBER}.zip"
	zip -r "$build_zip" "$DEPLOY_NAME"
	scp -rp "$build_zip" "$DEPLOY_TARGET"
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
