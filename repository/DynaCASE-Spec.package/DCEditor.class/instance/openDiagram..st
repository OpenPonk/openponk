instance creation
openDiagram: aDiagram
	diagram := aDiagram.
	textEditorModel doItReceiver diagram: diagram.
	"todo: this shouldn't be hardcoded"
	(diagram isKindOf: DCFsm)
		ifTrue: [ diagramController := DCFsmController new ].
	(diagram isKindOf: DCUmliteDiagram)
		ifTrue: [ diagramController := DCUmliteController new ].
	diagramController model: diagram.
	diagramController initializePalette: paletteModel editor: self.
	paletteModel rebuildWidget.
	self reloadView