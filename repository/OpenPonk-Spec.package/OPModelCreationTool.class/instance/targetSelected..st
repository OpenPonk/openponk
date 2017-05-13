callbacks
targetSelected: aController
	(aController canBeTargetFor: objectController)
		ifFalse: [ ^ self ].
	aController addAsTargetFor: objectController.
	self palette deselectTool.
	objectController := nil