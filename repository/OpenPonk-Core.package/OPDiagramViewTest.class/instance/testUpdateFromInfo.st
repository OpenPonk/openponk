tests
testUpdateFromInfo
	| info |
	info := OPDiagramViewInfo new
		isOpen: true;
		isSelected: false;
		order: 7.
	view := OPDiagramView new updateFromInfo: info.
	self assert: info isOpen equals: view isOpen.
	self assert: info isSelected equals: view isSelected.
	self assert: info order equals: view order