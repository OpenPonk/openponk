selection handling
cancelSelection
	selectedElement ifNotNil: [ selectedElement cancel ].
	selectedElement := nil.
	selectedItem := nil.
	selectedItemType := #form.
	diagramController ifNotNil: [ diagramController deactivateAllElements ].
	self statusModel text: ''.
	self formModel editController: nil