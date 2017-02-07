private
selectEntry: anEntry
	selectedTool
		ifNotNil: [ selectedTool deselect.
			selectedItem state: false ].
	selectedTool := anEntry tool.
	selectedItem := anEntry.
	anEntry select