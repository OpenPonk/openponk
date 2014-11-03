actions
deselect
	selectedController
		ifNotNil: [ 
			selectedController hideSelectionFeedback.
			self workbench openFormOn: nil ]