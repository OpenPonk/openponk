selection handling
cancelSelection
	selectedItem
		ifNotNil: [ 
			selectedElement
				ifNotNil: [ 
					selectedElement cancel.
					selectedElement := nil ].
			selectedItem := nil.
			selectedItemType := nil ]