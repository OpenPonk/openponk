tests
testModel
	| comp project |
	comp := NSMComponent new
		name: 'testComp';
		version: '1.0'.
	project := NSPProject new.
	project addModel: comp.
	view := OPDiagramView new
		modelName: 'testComp';
		modelVersion: '1.0';
		modelType: 'Component';
		project: project.
	self assert: view model equals: comp