as yet unclassified
openProjectFromFolder: aFolder
	| reader newProject |
	reader := OPPersistenceProjectReader new.
	newProject := reader fromFolder: aFolder.
	newProject open