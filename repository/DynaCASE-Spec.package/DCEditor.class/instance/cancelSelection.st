selection handling
cancelSelection
	selectedElement ifNotNil: [ selectedElement cancel ].
	selectedElement := nil.
	selectedItem := nil.
	selectedItemType := #form.
	self statusModel text: ''.
	self formModel editController: nil.