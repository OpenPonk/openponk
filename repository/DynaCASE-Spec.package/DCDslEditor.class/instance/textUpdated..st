event handling
textUpdated: aString
	location ifNil: [ self updateModel ] ifNotNil: [ self saveToFile: location ]