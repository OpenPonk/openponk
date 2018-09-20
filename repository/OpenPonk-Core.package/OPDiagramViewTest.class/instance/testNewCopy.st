tests
testNewCopy
	| model project newView |
	model := OPTestContainerModel new.
	project := OPProject new.
	project addModel: model.
	view := OPDiagramView new
		name: 'original';
		camera:
			(OPDiagramViewCamera new
				offset: 20 @ 30;
				zoom: 1.2);
		model: model;
		project: project;
		isOpen: true;
		isSelected: false;
		order: 7.
	newView := view newCopy.
	self deny: newView = view.
	self assert: newView name equals: 'copy of original'.
	self assert: newView project equals: project.
	self assert: newView model equals: model.
	self
		assert: (project views includes: newView)
		description: [ 'Opposite test, because clone bypasses Synchronized Links' ].
	view