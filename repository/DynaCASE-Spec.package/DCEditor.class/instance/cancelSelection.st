selection handling
cancelSelection
	selectedElement := nil.
	selectedItem := nil.
	selectedItemType := #form.
	self statusModel text: ''.
	self formModel editController: nil.
	interactiveLine ifNotNil: [interactiveLine cancel].