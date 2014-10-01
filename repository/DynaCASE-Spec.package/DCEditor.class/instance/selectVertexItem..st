as yet unclassified
selectVertexItem: aControllerClass
	selectedItemType := #vertex.
	self selectItem: aControllerClass.
	self statusModel text: 'Click to the view to add an element.'