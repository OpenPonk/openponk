diagram handling
openDiagram: aDiagram
	diagramController := self newDiagramControllerFor: aDiagram.
	self workbench projectController addDiagramController: diagramController.
	canvasModel attachController: diagramController.
	canvasMenuModel
		fromSpec: (DCPragmaPluginMenuBuilder pragmaKeyword: #dcCanvasToolbar: model: canvasModel) menuSpec.
	self rebuildWidget.
	canvasModel reloadView.
	self applyLayoutFor: aDiagram.
	diagramController saveState