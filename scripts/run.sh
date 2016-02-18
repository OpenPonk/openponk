#!/bin/bash

readonly IMAGE="dynacase.image"
readonly VMS=vms

# will be loaded dynamically
PHARO_VM=
OS=

setup() {
	detect-os

	if [ "$OS" == "win" ]; then
		PHARO_VM=$(find $VMS/windows -name Pharo.exe)
	elif [ "$OS" == "mac" ]; then
		PHARO_VM=$(find $VMS/mac -name pharo)
	elif [ "$OS" == "linux" ]; then
		PHARO_VM=$(find $VMS/linux -name pharo | tail -n 1)
	fi
}


detect-os() {
	local tmp_os=`uname | tr "[:upper:]" "[:lower:]"`
	case "$tmp_os" in
		*darwin*)
			OS="mac"
			;;
		*linux*)
			OS="linux"
			;;
		*win* | *mingw*)
			OS="win"
			;;
		*)
			echo "Unsupported OS '$tmp_os'"
			exit 1
	esac
}

debian-64bit-instructions() {
	cat <<- EOF
		sudo dpkg --add-architecture i386
		sudo apt-get update
		sudo apt-get install libx11-6:i386 libgl1-mesa-glx:i386 libfontconfig1:i386 libssl1.0.0:i386
	EOF
}

assert-64bit() {
	if [[ "$OS" == "linux" ]]; then
		$PHARO_VM --help &> /dev/null 2>&1
		if [[ $? -ne 0 ]]; then
			cat <<- EOF
				On a 64-bit system? You must install the 32-bit libraries.
				On Debian 8+, try running:

				$(debian-64bit-instructions)

				or see https://pharo.org/gnu-linux-installation#64-bit-System-Setup for more info.
			EOF
			exit 1
		fi
	fi
}

assert-cairo() {
	local has_cairo="$VMS/.has-cairo"
	if [[ -e $has_cairo ]]; then
		return
	fi

	local headless='--headless'
	if [[ $OS == "linux" ]]; then
		headless='--nodisplay'
	fi
	$PHARO_VM $headless $IMAGE eval 'CairoLibrary uniqueInstance moduleName' > /dev/null

	if [[ $? -ne 0 ]]; then
		cat <<- EOF
			Cannot locate cairo library. Please check if it installed on your system
			On Debian, try running:

			sudo apt-get install libcairo2:i386

			For other platforms see http://cairographics.org/download/ (note that you need 32bit library)
		EOF
		exit 1
	fi

	echo 'true' >> $has_cairo
}

run() {
	$PHARO_VM $IMAGE
}

main() {
	setup
	assert-64bit
	assert-cairo
	run
}

main
