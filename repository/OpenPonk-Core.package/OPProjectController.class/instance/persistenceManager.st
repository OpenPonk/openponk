accessing
persistenceManager
	^ persistenceManager ifNil: [ persistenceManager := OPProjectDirectoryPersistence new ]