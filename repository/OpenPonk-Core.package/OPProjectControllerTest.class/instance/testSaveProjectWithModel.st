tests
testSaveProjectWithModel
	| memoryRoot root |
	project addModel: OPTestContainerModel new.
	memoryRoot := FileSystem memory / 'project'.
	self deny: memoryRoot exists.
	controller saveProjectTo: memoryRoot.
	root := (FileSystem zip: memoryRoot) open root.
	self assert: (root / 'project.json') exists.
	self
		assert: ((root / 'models') children collect: #basename)
		equals: {project models first uuid asString}.
	self
		assert: ((root / 'models') children anyOne children collect: #basename)
		equals: (Array with: 'model.ston')