signalling
reloadView
	self cleanView.
	diagramController ifNotNil: [ self loadElementsFromController ].
	self addCanvasMenu.
	diagramController ifNotNil: [ diagramController updateView ]