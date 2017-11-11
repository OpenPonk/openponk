adding
addDiagramController: aController
	self subscribeTo: aController.
	controllers add: aController