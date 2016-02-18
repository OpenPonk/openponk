#!/bin/bash
set -o nounset
set -o errexit

readonly VERSION=50
readonly PHARO_FILES="http://files.pharo.org/get-files/$VERSION"

curl_download() {
	local output=$1
	local url=$2
	curl --silent --location --compressed --output $output $url
}

download_vm() {
	local os=$1
	local vm_dir=$2/$1
	local url="$PHARO_FILES/pharo-$os-stable.zip"
	local zip=$vm_dir/vm.zip
	mkdir -p $vm_dir
	curl_download $zip $url
	unzip -q $zip -d $vm_dir
	rm -f $zip
}

download_sources() {
	local vm_dir=$1
	local zip=$vm_dir/sources.zip
	curl_download $zip "$PHARO_FILES/sources.zip"
	unzip -q $zip -d $vm_dir
	rm -f $zip
}

download_all() {
	local vm_dir=$1
	mkdir -p $vm_dir
	download_sources $vm_dir
	local sources=$(find vms -maxdepth 1 -name '*.sources')

	for os in linux win mac; do
		download_vm $os $vm_dir
	done
	cp $sources $vm_dir/linux
	cp $sources $vm_dir/win
	cp $sources $(find vms -type d -name Resources)
	rm -f $sources
}

main() {
	local dir=vms
	download_all $dir
	zip -qr vms.zip $vm_dir
}

main
