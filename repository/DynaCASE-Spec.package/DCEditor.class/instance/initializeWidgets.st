initialization
initializeWidgets
	roassalModel := self instantiate: RoassalModel.
	paletteModel := self instantiate: DCSmPalette.
	statusModel := self newText.
	formModel := DCForm new.
	(self focusOrder)
		add: roassalModel;
		add: paletteModel;
		add: formModel;
		add: statusModel