accessing
autosaveManager
	^ autosaveManager
		ifNil: [ autosaveManager := OPAutosaveManager on: self plugin serializerClass new ]