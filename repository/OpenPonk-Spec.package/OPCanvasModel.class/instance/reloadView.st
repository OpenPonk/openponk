signalling
reloadView
	self deprecated: 'Control reloading from Controller, not Canvas'.
	self cleanView.
	diagramController ifNotNil: [ self loadElementsFromController ].
	diagramController ifNotNil: [ diagramController updateView ]