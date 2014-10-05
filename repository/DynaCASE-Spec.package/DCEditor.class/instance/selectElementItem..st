as yet unclassified
selectElementItem: aControllerClass
	selectedItemType := #element.
	self selectItem: aControllerClass.
	self statusModel text: 'Click to the view to add an element.'