diagram handling
openView: aView model: aModel
	diagramController := self newDiagramControllerFor: aModel.
	self workbench projectController addDiagramController: diagramController.
	canvasModel attachController: diagramController.
	self rebuildWidget.
	canvasModel reloadView.
	self applyLayoutFor: aModel.
	diagramController applyView: aView.
	diagramController saveState