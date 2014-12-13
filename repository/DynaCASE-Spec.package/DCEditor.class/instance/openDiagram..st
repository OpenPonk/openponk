diagram handling
openDiagram: aDiagram
	| layout |
	diagramController ifNotNil: [ self closeDiagram ].
	textEditorModel doItReceiver diagram: aDiagram.
	diagramController := self newDiagramControllerFor: aDiagram.
	self workbench projectController addDiagramController: diagramController.
	self rebuildPalette.
	canvasModel diagramController: diagramController.
	canvasModel reloadView.
	layout := self workbench projectController layoutFor: aDiagram.
	layout ifNotNil: [ diagramController layout: layout ]