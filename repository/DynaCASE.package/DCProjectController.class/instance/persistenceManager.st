accessing
persistenceManager
	^ persistenceManager ifNil: [ persistenceManager := DCPersistenceManager new ]