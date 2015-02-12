protocol
deselect
	selectedController
		ifNotNil: [ 
			selectedController hideSelectionFeedback.
			selectedController := nil.
			self workbench openFormOn: nil ]