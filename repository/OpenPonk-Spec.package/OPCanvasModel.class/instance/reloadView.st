signalling
reloadView
	self cleanView.
	diagramController ifNotNil: [ self loadElementsFromController ].
	diagramController ifNotNil: [ diagramController updateView ]