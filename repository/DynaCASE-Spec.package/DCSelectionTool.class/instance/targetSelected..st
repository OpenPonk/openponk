actions
targetSelected: aController
	selectedController ifNotNil: [ selectedController hideSelectionFeedback ].
	selectedController := aController.
	selectedController showSelectionFeedback.
	self workbench openFormOn: selectedController