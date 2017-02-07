private
selectItem: anItem tool: aTool
	selectedTool
		ifNotNil: [ 
			selectedTool deselect.
			selectedItem state: false ].
	(selectedTool := aTool) select.
	(selectedItem := anItem) state: true