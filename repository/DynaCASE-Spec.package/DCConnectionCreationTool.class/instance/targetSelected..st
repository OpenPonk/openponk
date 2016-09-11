callbacks
targetSelected: aController
	(aController canBeTargetFor: connectionController)
		ifFalse: [ ^ self ].
	aController addAsTargetFor: connectionController.
	self palette deselectTool.
	self palette selectedTool targetSelected: connectionController.
	onComplete value: connectionController.
	connectionController := nil.
	self deselect