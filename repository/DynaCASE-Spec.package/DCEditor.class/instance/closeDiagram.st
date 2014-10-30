diagram handling
closeDiagram
	textEditorModel doItReceiver diagram: nil.
	diagramController remove.
	diagramController := nil.
	self rebuildPalette.
	canvasModel diagramController: nil.
	canvasModel reloadView