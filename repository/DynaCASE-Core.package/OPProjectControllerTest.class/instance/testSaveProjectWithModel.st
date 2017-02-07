tests
testSaveProjectWithModel
	| root |
	project addModel: OPNamedElement new.
	root := FileSystem memory / 'project'.
	self deny: root exists.
	controller saveProjectTo: root.
	self assert: (root / 'project.xml') exists.
	self
		assert: ((root / 'models') children collect: #basename)
		equals: {project models first uuid asString}.
	self
		assert: ((root / 'models') children anyOne children collect: #basename)
		equals: (Array with: 'model.ston')