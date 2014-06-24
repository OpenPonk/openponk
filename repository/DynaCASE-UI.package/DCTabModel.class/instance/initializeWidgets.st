initialization
initializeWidgets
	canvasMorph := DCCanvasMorph new asSpecAdapter.
	statusText := self newText.
	paletteModel := self defaultPaletteModel.
	formModel := DCForm new.
	self focusOrder add: statusText