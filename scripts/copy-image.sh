#!/bin/bash

set -euo pipefail

readonly SOURCE_IMAGE=$1
readonly SOURCE_NAME=${SOURCE_IMAGE%.image}
readonly TARGET_NAME=$2

copy_image() {
	mkdir -p $(dirname $TARGET_NAME)
	cp "$SOURCE_NAME.image" "$TARGET_NAME.image"
	cp "$SOURCE_NAME.changes" "$TARGET_NAME.changes"
}

copy_image
