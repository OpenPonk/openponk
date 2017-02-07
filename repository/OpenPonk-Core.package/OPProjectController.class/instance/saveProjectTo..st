saving
saveProjectTo: aFolder
	self persistenceManager
		saveProject: self project
		withMementos: self modelMementos
		to: aFolder asFileReference