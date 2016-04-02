accessing
autosaveManager
	^ autosaveManager
		ifNil: [ autosaveManager := DCAutosaveManager on: self plugin serializerClass new ]