selection handling
cancelSelection
	activeElementsController
		ifNotNil: [ 
			activeElementsController deactivateLevel: 20.
			activeElementsController := nil ].
	roassalView ifNotNil: [ roassalView signalUpdate ].
	selectedElement ifNotNil: [ selectedElement cancel ].
	selectedElement := nil.
	selectedItem := nil.
	selectedItemType := #form.
	self statusModel text: ''.
	self formModel editController: nil