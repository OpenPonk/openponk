tests
testModel
	| model project |
	model := OPTestContainerModel new.
	project := OPProject new.
	project addModel: model.
	view := OPDiagramView new
		modelName: 'container';
		modelType: 'OPTestContainerModel';
		project: project.
	self assert: view model equals: model