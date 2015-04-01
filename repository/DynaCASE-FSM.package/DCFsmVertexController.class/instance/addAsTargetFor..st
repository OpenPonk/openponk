adding
addAsTargetFor: aController
	| newModel |
	self assert: (self canBeTargetFor: aController).
	aController target: self.
	aController diagramController: self diagramController.
	newModel := aController createModel.
	self diagramController model add: newModel.
	aController model: newModel.
	self diagramController controllers add: aController.
	aController attach