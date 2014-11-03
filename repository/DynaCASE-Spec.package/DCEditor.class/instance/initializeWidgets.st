initialization
initializeWidgets
	textEditorModel := self newText.
	canvasModel := self instantiate: DCCanvasModel.
	paletteModel := self instantiate: DCPalette.
	self focusOrder
		add: canvasModel;
		add: paletteModel;
		add: textEditorModel