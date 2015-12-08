initialization
initializeWidgets
	canvasMenuModel := self instantiate: MenuModel.
	canvasModel := self instantiate: DCCanvasModel.
	paletteModel := self instantiate: DCPalette.
	self focusOrder
		add: canvasMenuModel;
		add: canvasModel;
		add: paletteModel