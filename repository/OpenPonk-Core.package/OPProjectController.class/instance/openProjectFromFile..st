opening
openProjectFromFile: aFile
	| reader newProject store |
	store := OPZipPersistence new loadFrom: aFile.
	reader := OPPersistenceProjectReader new.
	newProject := reader fromFolder: store.
	newProject storageFile: aFile.
	newProject open