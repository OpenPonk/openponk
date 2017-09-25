#!/bin/bash

set -eu

SMALLTALK_VM=${SMALLTALK_VM:-$(find $SMALLTALK_CI_VMS -name pharo -type f -executable | head -n 1)}
readonly IMAGE="$1"

run_script() {
	local script=$1
	"$SMALLTALK_VM" --nodisplay "$IMAGE" --no-default-preferences eval --save "$script"
}

use_openponk_logo() {
	run_script "PolymorphSystemSettings showDesktopLogo: true.
PolymorphSystemSettings setDesktopLogoWith: (ImageMorph withForm: OPIcons current logo)."
}

main() {
	use_openponk_logo
}

main
