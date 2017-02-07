tests
testDirty
	| project  changed  |
	project := OPProject new.
	project whenChanged: [ changed := true ].

	changed := false.
	project projectName: 'new name'.
	self assert: changed.
	self assert: project dirty.

	changed := false.
	project beClean.
	self assert: changed.
	self deny: project dirty.

	changed := false.
	project beDirty.
	self assert: changed.
	self assert: project dirty