tests
testCreateFolderStructure
	| root |
	root := FileSystem memory root / 'project'.
	persistence saveProject: OPProject new to: root.
	self assert: root isDirectory.
	self assert: (root / 'project.json') isFile.
	self assert: (root / 'models.json') isFile.
	self assert: (root / 'models') isDirectory.
	self assert: (root / '.history' / 'models') isDirectory