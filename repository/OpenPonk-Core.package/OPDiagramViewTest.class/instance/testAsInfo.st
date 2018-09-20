tests
testAsInfo
	| info |
	view := OPDiagramView new
		name: 'default';
		model: OPTestContainerModel new;
		isOpen: true;
		isSelected: false;
		order: 7.
	info := view asInfo.
	self assert: info viewName equals: view name.
	self assert: info modelName equals: view modelName.
	self assert: info modelVersion equals: view modelVersion.
	self assert: info modelType equals: view modelType.
	self assert: info isOpen equals: view isOpen.
	self assert: info isSelected equals: view isSelected.
	self assert: info order equals: view order