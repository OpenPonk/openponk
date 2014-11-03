private
selectItem: anItem tool: aTool
	selectedTool
		ifNotNil: [ 
			selectedTool deselect.
			selectedItem state: false ].
	selectedTool := aTool.
	selectedTool select.
	selectedItem := anItem.
	selectedItem state: true