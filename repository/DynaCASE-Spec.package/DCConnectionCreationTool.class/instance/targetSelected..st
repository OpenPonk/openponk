callbacks
targetSelected: aController
	(aController canBeTargetFor: connectionController)
		ifTrue: [ 
			aController addAsTargetFor: connectionController.
			self palette deselectTool: self ]