as yet unclassified
openProjectFromDirectory
	| folder |
	folder := UIManager default chooseDirectory: 'Choose directory containing the project'.
	folder ifNil: [ ^ self ].
	self openProject: (OPPersistenceProjectReader new fromFolder: folder)