instance creation
openDiagram: aDiagram
	diagramController ifNotNil: [ self closeDiagram ].
	textEditorModel doItReceiver diagram: aDiagram.
	diagramController := self newDiagramControllerFor: aDiagram.
	diagramController initializeTree: treeModel.
	self rebuildPalette.
	canvasModel diagramController: diagramController.
	self canvasModel reloadView