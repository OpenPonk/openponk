#!/bin/bash

set -euxo pipefail

prepare_directory() {

	local platform=$1
	local package_dir_name="openponk-$PROJECT_NAME-$platform"
	local working_dir="$package_dir_name-$BUILD_VERSION"
	local package_dir="$working_dir/$package_dir_name"

	mkdir -p "$package_dir"

	cp $SMALLTALK_CI_IMAGE $package_dir/openponk-$PROJECT_NAME.image
	cp $SMALLTALK_CI_CHANGES $package_dir/openponk-$PROJECT_NAME.changes
	cp $SMALLTALK_CI_BUILD_BASE/*.sources $package_dir
	echo "$PHARO_VERSION_SIMPLE" > $package_dir/pharo.version
}

download_vm() {

	local platform=$1
	local vm_dir=$2
	local zip="$vm_dir/vm.zip"
	
	mkdir -p "$vm_dir"

	curl --location --compressed --output "$zip" "http://files.pharo.org/get-files/$PHARO_VERSION_SIMPLE/pharo${PHARO_BITS//32}-${platform}-stable.zip"
	unzip "$zip" -d "$vm_dir"
	rm "$zip"
}

upload() {	

	local platform=$1
	local package_dir_name="openponk-$PROJECT_NAME-$platform"
	local working_dir="$package_dir_name-$BUILD_VERSION"
	local zip="$package_dir_name-latest.zip"

	cd "$working_dir"
	zip -qr "$zip" "${package_dir_name}"
	
	set +x
		echo "curl -v -T $zip -ujanbliznicenko:BINTRAY_KEY https://api.bintray.com/content/openponk/builds/packages/1/${PROJECT_NAME}/$BUILD_VERSION/${zip}?publish=1&override=1"
		curl -v -T $zip -ujanbliznicenko:"${BINTRAY_KEY}" https://api.bintray.com/content/openponk/builds/packages/1/"${PROJECT_NAME}"/"${BUILD_VERSION}"/"${zip}"?"publish=1&override=1"
	set -x	
	
	cd ..
}

deploy_linux() {

	local platform="linux"

	local package_dir_name="openponk-$PROJECT_NAME-$platform"
	local working_dir="$package_dir_name-$BUILD_VERSION"
	local package_dir="$working_dir/$package_dir_name"
	local vm_dir="$package_dir"

	prepare_directory $platform
#	download_vm "$platform-threaded" $vm_dir

	rm $vm_dir/pharo
	cat << EOF > $vm_dir/openponk-$PROJECT_NAME
#!/bin/bash
./bin/pharo openponk-$PROJECT_NAME.image
EOF
	chmod a+rx $vm_dir/openponk-$PROJECT_NAME

	upload $platform

}

deploy_windows() {

	local platform="win"

	local package_dir_name="openponk-$PROJECT_NAME-$platform"
	local working_dir="$package_dir_name-$BUILD_VERSION"
	local package_dir="$working_dir/$package_dir_name"
	local vm_dir="$package_dir"

	prepare_directory $platform
	download_vm $platform $vm_dir
	
	mv $vm_dir/*haro.exe $vm_dir/openponk-$PROJECT_NAME.exe
	rm $vm_dir/*haroConsole.exe
	rm $vm_dir/*Zone.Identifier || true

	upload $platform

}

deploy_image() {
	
	local platform="pharo-image"

	local package_dir_name="openponk-$PROJECT_NAME-$platform"
	local working_dir="$package_dir_name-$BUILD_VERSION"
	local package_dir="$working_dir/$package_dir_name"

	prepare_directory $platform

	upload $platform

}

prepare_version_info() {
	local platform="linux"

	local package_dir_name="openponk-$PROJECT_NAME-$platform"
	local working_dir="$package_dir_name-$BUILD_VERSION"
	local package_dir="$working_dir/$package_dir_name"
	local vm_dir="$package_dir"

	download_vm "$platform-threaded" $vm_dir

	local version_info="{\"version\":\"${BUILD_VERSION}\",\"build_number\":${TRAVIS_BUILD_NUMBER},\"build_timestamp\":\"${BUILD_TIMESTAMP}\",\"project_name\":\"${PROJECT_NAME}\"}"
	echo "${version_info}" > version-info.json
	"${vm_dir}"/pharo --encoding utf8 -vm-display-null -vm-sound-null $SMALLTALK_CI_IMAGE eval --save "Transcript show: (NeoJSONReader fromString: '${version_info}') asString. OPVersion currentFromJSON: '${version_info}'"
}

upload_version_info() {
	echo uploading version info
	cat version-info.json
	ls -al
	set +x
		echo "curl -v -T version-info.json -ujanbliznicenko:BINTRAY_KEY https://api.bintray.com/content/openponk/builds/packages/1/${PROJECT_NAME}/${BUILD_VERSION}/version-info.json?publish=1&override=1"
		curl -v -T version-info.json -ujanbliznicenko:"${BINTRAY_KEY}" https://api.bintray.com/content/openponk/builds/packages/1/"${PROJECT_NAME}"/"${BUILD_VERSION}"/"version-info.json"?"publish=1&override=1"
	set -x
}

main() {

	export PHARO_VERSION_SIMPLE="${PHARO_VERSION//.}"
	export PHARO_BITS_NAME="${PHARO_BITS}b"
	export PHARO_FULL_VERSION="pharo$PHARO_VERSION-$PHARO_BITS_NAME"

	prepare_version_info
	deploy_image
	deploy_linux
	deploy_windows
	upload_version_info
}

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
	export BUILD_VERSION="latest"
	main
fi

if [[ -n "$TRAVIS_TAG" ]]; then
	export BUILD_VERSION="$TRAVIS_TAG"
	main
fi

return 0

