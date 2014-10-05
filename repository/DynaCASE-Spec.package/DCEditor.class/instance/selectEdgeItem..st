as yet unclassified
selectEdgeItem: aControllerClass
	self cancelSelection.
	selectedItemType := #edge.
	self selectItem: aControllerClass.
	self statusModel text: 'Click on the first of two elements to connect them.'.