diagram handling
openModel: aModel
	diagramController := self newDiagramControllerFor: aModel.
	self workbench projectController addDiagramController: diagramController.
	canvasModel attachController: diagramController.
	canvasMenuModel
		fromSpec: (OPPragmaPluginMenuBuilder pragmaKeyword: #opCanvasToolbar: model: canvasModel) menuSpec.
	self rebuildWidget.
	canvasModel reloadView.
	self applyLayoutFor: aModel.
	diagramController saveState