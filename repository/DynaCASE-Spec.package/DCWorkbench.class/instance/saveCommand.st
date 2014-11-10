menu actions
saveCommand
	project fileName
		ifNil: [ project fileName: ((self askForFileNameToSave: project projectName , '.ston') ifNil: [ ^ self ]) ].
	self saveFile: project fileName