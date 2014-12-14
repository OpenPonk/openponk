menu actions
saveCommand
	project fileName
		ifNil: [ project fileName: (self askForFileNameToSave ifNil: [ ^ self ]) fullName ].
	self saveFile: project fileName