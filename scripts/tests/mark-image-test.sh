#!/usr/bin/env bats

readonly SMALLTALK_VM=openponk/vms/linux/pharo
export SMALLTALK_VM

pharo-eval() {
	local script="$1"
	$SMALLTALK_VM --nodisplay openponk/openponk.image --no-default-preferences eval "$script"
}

@test "logo has been enabled" {
	pharo-eval "PolymorphSystemSettings showDesktopLogo: false"
	../mark-image.sh openponk/openponk.image
	run pharo-eval "PolymorphSystemSettings showDesktopLogo"
	[ "$output" = "true" ]
}

setup() {
	if [ ! -e openponk/openponk.image ]; then
		local build="openponk-linux-bleedingEdge.zip"
		wget "https://openponk.ccmi.fit.cvut.cz/builds/all-in-one/linux/${build}"
		unzip "$build"
	fi
	[ -e openponk/openponk.image ]
}
