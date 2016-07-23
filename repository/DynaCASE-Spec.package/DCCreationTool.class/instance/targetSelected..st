callbacks
targetSelected: aController
	(aController canBeTargetFor: objectController)
		ifFalse: [ ^ self ].
	aController addAsTargetFor: objectController.
	self palette deselectTool.
	self palette selectedTool targetSelected: objectController.
	onComplete value: objectController.
	objectController := nil