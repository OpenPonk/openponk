menu actions
saveAsCommand
	| suggestedFileName |
	suggestedFileName := self askForFileNameToSave: self suggestedFileName.
	suggestedFileName ifNil: [ ^ self ].
	fileName := suggestedFileName.
	self saveFile: suggestedFileName