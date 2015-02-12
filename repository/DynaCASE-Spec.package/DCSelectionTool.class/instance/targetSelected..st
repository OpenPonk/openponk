protocol
targetSelected: aController
	selectedController ifNotNil: [ selectedController hideSelectionFeedback ].
	(selectedController := aController) showSelectionFeedback.
	self workbench openFormOn: selectedController