diagram handling
closeDiagram
	textEditorModel doItReceiver diagram: nil.
	diagramController := nil.
	self rebuildPalette.
	canvasModel diagramController: nil.
	canvasModel reloadView