diagram handling
openDiagram: aDiagram
	diagramController := self newDiagramControllerFor: aDiagram.
	self workbench projectController addDiagramController: diagramController.
	self rebuildPalette.
	canvasModel attachController: diagramController.
	canvasModel reloadView.
	self applyLayoutFor: aDiagram