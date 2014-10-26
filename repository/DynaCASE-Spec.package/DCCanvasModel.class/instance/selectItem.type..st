selection handling
selectItem: aBlock type: aSymbol
	self cancelSelection.
	selectedItem := aBlock.
	selectedItemType := aSymbol