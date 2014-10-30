initialization
initializeWidgets
	textEditorModel := self newText.
	canvasModel := self instantiate: DCCanvasModel.
	paletteModel := self instantiate: DCPaletteModel.
	self focusOrder
		add: canvasModel;
		add: paletteModel;
		add: textEditorModel