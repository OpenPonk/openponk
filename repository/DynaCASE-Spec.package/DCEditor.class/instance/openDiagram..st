instance creation
openDiagram: aDiagram
	diagram := aDiagram.
	(diagram isKindOf: DCUmlClassDiagram)
		ifTrue: [ diagramController := DCUmlController new model: diagram ].
	(diagram isKindOf: DCFsm)
		ifTrue: [ diagramController := DCFsmController new model: diagram ].
	diagramController initializePalette: paletteModel editor: self.
	paletteModel rebuildWidget.
	self reloadView