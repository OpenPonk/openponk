callbacks
targetSelected: aController
	(aController canBeTargetFor: objectController)
		ifTrue: [ 
			aController addAsTargetFor: objectController.
			self palette deselectTool.
			self palette selectedTool targetSelected: objectController ]