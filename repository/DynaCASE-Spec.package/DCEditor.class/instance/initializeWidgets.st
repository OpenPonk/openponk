initialization
initializeWidgets
	"	statusModel := self newText."

	"	formModel := self instantiate: DCForm."

	roassalModel := self instantiate: RoassalModel.
	paletteModel := self instantiate: DCPaletteModel.
	self selectFsmPalette.
	self focusOrder
		add: roassalModel;
		add: paletteModel;
		add: formModel;
		add: statusModel