private
selectTool: aTool
	selectedTool
		ifNotNil: [ selectedTool deselect.
			selectedItem state: false ].
	(selectedTool := aTool) select