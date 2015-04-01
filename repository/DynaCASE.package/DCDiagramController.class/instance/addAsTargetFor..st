adding
addAsTargetFor: aController
	| newModel |
	self assert: (self canBeTargetFor: aController).
	newModel := aController createModel.
	self model add: newModel.
	aController
		diagramController: self diagramController;
		model: newModel.
	self diagramController controllers add: aController.
	aController attach.
	self view signalUpdate