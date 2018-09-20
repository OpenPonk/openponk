tests
testNewCopy
	| comp project newView |
	comp := NSMComponent new
		name: 'testComp';
		version: '1.0'.
	project := NSPProject new.
	project addModel: comp.
	view := OPDiagramView new
		name: 'original';
		camera:
			(OPDiagramViewCamera new
				offset: 20 @ 30;
				zoom: 1.2);
		model: comp;
		project: project;
		isOpen: true;
		isSelected: false;
		order: 7.
	newView := view newCopy.
	self deny: newView = view.
	self assert: newView name equals: 'copy of original'.
	self assert: newView project equals: project.
	self assert: newView model equals: comp.
	self
		assert: (project views includes: newView)
		description: [ 'Opposite test, because clone bypasses Synchronized Links' ].
	view