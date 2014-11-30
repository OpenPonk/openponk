diagram handling
openDiagram: aDiagram
	| layout |
	diagramController ifNotNil: [ self closeDiagram ].
	textEditorModel doItReceiver diagram: aDiagram.
	diagramController := self newDiagramControllerFor: aDiagram.
	layout := self workbench projectController layoutFor: aDiagram.
	layout ifNotNil: [ diagramController layout: layout ].
	self rebuildPalette.
	canvasModel diagramController: diagramController.
	canvasModel reloadView