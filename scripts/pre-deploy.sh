#!/bin/bash

set -o errexit

SMALLTALK_VM="$(find $SMALLTALK_CI_VMS -name pharo -type f -executable | head -n 1) --nodisplay"

use_logo() {
	$SMALLTALK_VM --nodisplay $SMALLTALK_CI_IMAGE eval --save "PolymorphSystemSettings showDesktopLogo: true.
PolymorphSystemSettings setDesktopLogoWith: (ImageMorph withForm: DCIcons current logo)."
}

before_deploy() {
	use_logo
}

main() {
	before_deploy
	echo "Final preparations completed"
}

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
	main
fi
