initialization
initializeWidgets
	canvasMenuModel := self instantiate: MenuModel.
	canvasModel := self instantiate: DCCanvasModel.
	paletteModel := self instantiate: DCPalette.
	(zoomLabel := self newLabel) label: '100%'.
	self focusOrder
		add: canvasMenuModel;
		add: canvasModel;
		add: paletteModel