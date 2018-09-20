tests
testIsForView
	| info view |
	view := OPDiagramView new
		name: 'default';
		modelType: 'Component';
		modelName: 'testComp';
		modelVersion: '1.0'.
	info := view asInfo.
	self assert: (info isForView: view).
	info := view asInfo viewName: 'other'.
	self deny: (info isForView: view).
	info := view asInfo modelType: 'Flow'.
	self deny: (info isForView: view).
	info := view asInfo modelName: 'otherComp'.
	self deny: (info isForView: view).
	info := view asInfo modelVersion: '1.1'.
	self deny: (info isForView: view)