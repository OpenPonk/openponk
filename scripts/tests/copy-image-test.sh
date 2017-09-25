#!/usr/bin/env bats

@test "copy image to dir" {
	mkdir -p src
	echo "image" > src/OLD.image
	echo "changes" > src/OLD.changes
	../copy-image.sh src/OLD.image dst/NEW
	[ -d dst ]
	[ -f dst/NEW.image ]
	[ -f dst/NEW.changes ] 
	cmp --silent src/OLD.image dst/NEW.image
	cmp --silent src/OLD.changes dst/NEW.changes
}

teardown() {
	rm -rf src dst
}
