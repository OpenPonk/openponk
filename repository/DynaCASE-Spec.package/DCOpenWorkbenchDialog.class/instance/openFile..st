file support
openFile: aFileName
	aFileName isEmptyOrNil
		ifTrue: [ ^ self ].
	DCWorkbench openFromFile: aFileName.
	self delete