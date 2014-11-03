accessing
createPaletteFor: aDiagramController
	diagramController := aDiagramController.
	self removeAll.
	diagramController initializePalette: self.
	self selectSelectionTool