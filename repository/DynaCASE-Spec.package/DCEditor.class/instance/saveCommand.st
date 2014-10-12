menu actions
saveCommand
	fileName ifNil: [ ^ self saveAsCommand ].
	self saveFile: fileName