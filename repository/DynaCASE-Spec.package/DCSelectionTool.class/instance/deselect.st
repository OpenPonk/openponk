protocol
deselect
	selectedController hideSelectionFeedback.
	selectedController := DCPaletteNullController new.
	self workbench openFormOn: nil