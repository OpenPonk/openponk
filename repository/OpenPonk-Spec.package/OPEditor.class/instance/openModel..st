diagram handling
openModel: aModel
	self deprecated: 'use openView:model: instead.'.
	diagramController := self newDiagramControllerFor: aModel.
	self workbench projectController addDiagramController: diagramController.
	canvasModel attachController: diagramController.
	self rebuildWidget.
	canvasModel reloadView.
	self applyLayoutFor: aModel.
	diagramController saveState