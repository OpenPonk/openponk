protocol
createPaletteFor: aDiagramController
	diagramController := aDiagramController.
	self removeAll.
	diagramController initializePalette: self.
	self selectSelectionTool.
	diagramController whenDeselectionChanged: [ self deselectTool ]