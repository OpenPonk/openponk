tests
testDirty
	| project  changed  |
	project := DCProject new.
	project whenChanged: [ changed := true ].

	changed := false.
	project projectName: 'new name'.
	self assert: changed.
	self assert: project dirty.

	changed := false.
	project setClean.
	self assert: changed.
	self deny: project dirty.

	changed := false.
	project setDirty.
	self assert: changed.
	self assert: project dirty