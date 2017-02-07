initialization
initializeWidgets
	canvasMenuModel := self instantiate: MenuModel.
	canvasModel := self instantiate: OPCanvasModel.
	paletteModel := self instantiate: OPPalette.
	(zoomLabel := self newLabel) label: '100%'.
	self focusOrder
		add: canvasMenuModel;
		add: canvasModel;
		add: paletteModel