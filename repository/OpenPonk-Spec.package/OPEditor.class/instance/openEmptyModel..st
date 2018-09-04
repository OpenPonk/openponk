diagram handling
openEmptyModel: aModel
	diagramController := self newDiagramControllerFor: aModel.
	self workbench projectController addDiagramController: diagramController.
	canvasModel attachController: diagramController.
	self rebuildWidget