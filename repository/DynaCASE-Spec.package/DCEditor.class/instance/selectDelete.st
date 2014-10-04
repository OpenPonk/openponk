as yet unclassified
selectDelete
	self cancelSelection.
	selectedItemType := #delete.
	self selectItem: nil.
	self statusModel text: 'Click on any item to delete it.'.