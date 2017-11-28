saving
saveProjectTo: aFile
	| store |
	store := FileSystem memory root.
	self persistenceManager
		saveProject: self project
		withMementos: self modelMementos
		to: store.
	OPZipPersistence new save: store to: aFile