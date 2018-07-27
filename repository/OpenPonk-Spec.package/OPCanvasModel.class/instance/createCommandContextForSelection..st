private-focus
createCommandContextForSelection: selectedItems
	"simple context has no information about selected items"

	^ OPDiagramFigureContext for: self of: selectedItems
	"	^CmdContactBookPresenterContext for: self of: selectedContacts"