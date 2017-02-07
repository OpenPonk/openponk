accessing
projectFolder
	self project storageFolder
		ifNil: [ self project
				storageFolder: (UIManager default chooseDirectory: 'Choose Directory where your project should be stored') ].
	^ self project storageFolder