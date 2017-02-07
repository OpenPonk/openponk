adding
addAsTargetFor: aController
	| newModel |
	self assert: (self canBeTargetFor: aController).
	newModel := aController createModel.
	aController
		diagramController: self diagramController;
		model: newModel.
	self controllers add: aController.
	aController attach.
	self model add: newModel.
	self view signalUpdate