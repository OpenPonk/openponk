protocol
targetSelected: aController
	selectedController hideSelectionFeedback.
	(selectedController := aController) showSelectionFeedback.
	self workbench openFormOn: selectedController