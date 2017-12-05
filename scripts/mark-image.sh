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

close_pharo_help() {
	run_script "World submorphs select: [ :each | (each isKindOf: SystemWindow) and: [ each label = WelcomeHelp bookName ] ] thenDo: #delete."
}

set_version() {
	run_script "OPVersion gitCommit: '${TRAVIS_COMMIT}'"
}

main() {
	use_openponk_logo
	close_pharo_help
	set_version
}

main
