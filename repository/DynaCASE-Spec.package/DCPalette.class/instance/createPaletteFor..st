accessing
createPaletteFor: aDiagramController
	diagramController := aDiagramController.
	self removeAll.
	diagramController initializePalette: self.
	items first performAction