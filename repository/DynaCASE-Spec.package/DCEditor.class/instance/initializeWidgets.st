initialization
initializeWidgets
	canvasMenuModel := self instantiate: MenuModel.
	textEditorModel := self newText.
	canvasModel := self instantiate: DCCanvasModel.
	paletteModel := self instantiate: DCPalette.
	self focusOrder
		add: canvasMenuModel;
		add: canvasModel;
		add: paletteModel;
		add: textEditorModel