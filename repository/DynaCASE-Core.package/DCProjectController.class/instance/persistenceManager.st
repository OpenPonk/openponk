accessing
persistenceManager
	^ persistenceManager ifNil: [ persistenceManager := DCProjectDirectoryPersistence new ]