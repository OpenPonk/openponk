as yet unclassified
selectDelete
	selectedItemType := #delete.
	self selectItem: nil.
	self statusModel text: 'Click on any item to delete it.'