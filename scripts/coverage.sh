#!/bin/bash

# exit on first encountered error
set -o errexit

# wherever you'll be ssh-ing into user@machine
readonly TARGET_MACHINE="dynacase@ccmi.fit.cvut.cz"
readonly TARGET_DIR="~/builds/"
readonly COVERAGE_DIR=$(readlink -m $(dirname $SMALLTALK_CI_IMAGE))
readonly COVERAGE_IMAGE=$COVERAGE_DIR/coverage.image
readonly RESULT_FILE="coverage-${TRAVIS_BUILD_NUMBER}.json"
SMALLTALK_VM="$(find $SMALLTALK_CI_VMS -name pharo -type f -executable | head -n 1) --nodisplay"

copy_image() {
	$SMALLTALK_VM $SMALLTALK_CI_IMAGE save coverage
}

install_hapao() {
	$SMALLTALK_VM $COVERAGE_IMAGE eval --save "Gofer new smalltalkhubUser: 'ObjectProfile' project: 'Spy2'; configurationOf: 'Spy2'; loadBleedingEdge"
}

run_hapao() {
	$SMALLTALK_VM --nodisplay $COVERAGE_IMAGE eval "
|pkgs coverage totalCoverage|
pkgs := RPackage organizer packages select: [ :each |
	(each name beginsWith: 'DynaCASE') |
	(each name beginsWith: 'UML') |
	(each name beginsWith: 'Borm') |
	(each name beginsWith: 'DEMO')
].

coverage := (pkgs collect: [ :each |
	each name -> (Hapao2 runTestsForPackage: each) coverage
]) asDictionary.

totalCoverage := (Hapao2 runTestsForPackages: pkgs) coverage.
coverage at: #total put: totalCoverage.

'${RESULT_FILE}' asFileReference writeStreamDo: [ :stream |
	stream nextPutAll: (STON toJsonStringPretty: coverage)
].

totalCoverage."
}

run_coverage() {
	copy_image
	install_hapao
	run_hapao
	scp -p "$COVERAGE_DIR/$RESULT_FILE" "$TARGET_MACHINE:$TARGET_DIR"
}

main() {
	run_coverage
	echo "Coverage executed and stored in $RESULT_FILE"
}

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
	main
fi
