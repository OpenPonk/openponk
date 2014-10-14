selection handling
cancelSelection
	activeElement
		ifNotNil: [ 
			activeElement announce: DCTRUnselectedEvent.
			activeElement := nil ].
	roassalView ifNotNil: [ roassalView signalUpdate ].
	selectedElement ifNotNil: [ selectedElement cancel ].
	selectedElement := nil.
	selectedItem := nil.
	selectedItemType := #form.
	self statusModel text: ''.
	self formModel editController: nil