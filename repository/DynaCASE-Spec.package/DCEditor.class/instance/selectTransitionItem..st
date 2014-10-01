as yet unclassified
selectTransitionItem: aControllerClass
	selectedItemType := #transition.
	self selectItem: aControllerClass.
	self statusModel text: 'Click on two elements to connect them.'