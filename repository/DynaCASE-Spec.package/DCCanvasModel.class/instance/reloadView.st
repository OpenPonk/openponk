signalling
reloadView
	self cleanView.
	diagramController ifNotNil: [ self loadElementsFromController ].
	self createCanvasMenu.
	diagramController ifNotNil: [ diagramController updateView ]