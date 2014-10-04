as yet unclassified
selectEdgeItem: aControllerClass
	selectedItemType := #edge.
	self selectItem: aControllerClass.
	self statusModel text: 'Click on two elements to connect them.'