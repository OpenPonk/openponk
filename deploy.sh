#!/bin/bash
set -o nounset
set -o errexit
set -v


### TEMP

if [[ 1 -eq 0 ]]; then
	readonly SMALLTALK_CI_BUILD=smalltalkCI-master/_builds/2016_02_12_19_12_22
	readonly SMALLTALK_CI_IMAGE="$SMALLTALK_CI_BUILD/TravisCI.image"
	readonly SMALLTALK_CI_CHANGES="$SMALLTALK_CI_BUILD/TravisCI.changes"
	readonly SMALLTALK_CI_VM=smalltalkCI-master/_cache/vms/Pharo-5.0/pharo
	readonly SMALLTALK_CI_VMS=smalltalkCI-master/_cache/vms
	readonly TRAVIS_BUILD_NUMBER=20
fi

###


readonly DEPLOY_DIR="$SMALLTALK_CI_BUILD/deploy"
readonly DEPLOY_NAME="dynacase"
readonly SSH_IDENTITY=.ssh/id_dynacase_travis
readonly DEPLOY_TARGET="dynacase@ccmi.fit.cvut.cz:~/www/builds/"

prepare_deploy() {
	if [[ ! -d $DEPLOY_DIR ]]; then
		mkdir "$DEPLOY_DIR"
	fi
	cat > "$DEPLOY_DIR/run.sh" << EOF
#!/bin/sh
readonly VM_UI="vms/Pharo-5.0/pharo-ui"
readonly VM_UI="$(basename $(dirname "$SMALLTALK_CI_VM"))/pharo-ui"
\$VM_UI $DEPLOY_NAME.image
EOF
	chmod a+x $DEPLOY_DIR/run.sh
}

prepare_image() {
	cp "$SMALLTALK_CI_IMAGE" "$DEPLOY_DIR/$DEPLOY_NAME.image"
	cp "$SMALLTALK_CI_CHANGES" "$DEPLOY_DIR/$DEPLOY_NAME.changes"
}

install_all() {
	# install core
	$SMALLTALK_CI_VM $SMALLTALK_CI_IMAGE eval --save "Metacello new baseline: 'DynaCASE'; repository: 'github://dynacase/dynacase/repository'; load"
	# install BORM
	$SMALLTALK_CI_VM $SMALLTALK_CI_IMAGE eval --save "Metacello new baseline: 'BormEditor'; repository: 'github://dynacase/borm-editor/repository'; load"
	# install UML
	$SMALLTALK_CI_VM $SMALLTALK_CI_IMAGE eval --save "Metacello new baseline: 'DCUmlClassEditor'; repository: 'github://dynacase/class-editor/repository'; load"
}

prepare_vms() {
	cp -rv "$SMALLTALK_CI_VMS" "$DEPLOY_DIR"
}

deploy() {
	cd $DEPLOY_DIR
	local build_zip="${DEPLOY_NAME}-${TRAVIS_BUILD_NUMBER}.zip"
	zip -r "$build_zip" "run.sh" "$DEPLOY_NAME.image" "$DEPLOY_NAME.changes" "$(basename "$SMALLTALK_CI_VMS")"
	scp -rp "$build_zip" "$DEPLOY_TARGET"
}

main() {
	install_all
	prepare_deploy
	prepare_image
	prepare_vms
	deploy
}

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
	main
fi
