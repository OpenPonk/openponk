diagram handling
closeDiagram
	textEditorModel doItReceiver diagram: nil.
	self workbench projectController removeDiagramController: diagramController.
	diagramController remove.
	diagramController := nil.
	self rebuildPalette.
	canvasModel diagramController: nil.
	canvasModel reloadView