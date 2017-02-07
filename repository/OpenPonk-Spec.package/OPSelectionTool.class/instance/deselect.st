protocol
deselect
	selectedController hideSelectionFeedback.
	selectedController := OPPaletteNullController new.
	self workbench openFormOn: nil