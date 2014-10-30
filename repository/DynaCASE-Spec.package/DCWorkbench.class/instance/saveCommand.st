menu actions
saveCommand
	project fileName
		ifNil: [ 
			| suggestedFileName |
			suggestedFileName := self askForFileNameToSave: project projectName , '.ston'.
			suggestedFileName ifNil: [ ^ self ].
			project fileName: suggestedFileName ].
	self saveFile: project fileName