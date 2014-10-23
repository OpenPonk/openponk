diagram handling
openDiagram: aDiagram
	diagramController ifNotNil: [ self closeDiagram ].
	textEditorModel doItReceiver diagram: aDiagram.
	diagramController := self newDiagramControllerFor: aDiagram.
	self rebuildPalette.
	canvasModel diagramController: diagramController.
	canvasModel reloadView