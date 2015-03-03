initialization
initializeWidgets
	canvasMenuModel := self instantiate: DCEditorMenu.
	canvasModel := self instantiate: DCCanvasModel.
	paletteModel := self instantiate: DCPalette.
	self focusOrder
		add: canvasMenuModel;
		add: canvasModel;
		add: paletteModel