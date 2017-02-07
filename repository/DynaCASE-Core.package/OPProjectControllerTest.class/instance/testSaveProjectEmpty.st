tests
testSaveProjectEmpty
	| root |
	root := FileSystem memory / 'project'.
	self deny: root exists.
	controller saveProjectTo: root.
	self assert: (root / 'project.xml') exists.
	self assert: (root / 'models') children equals: #()