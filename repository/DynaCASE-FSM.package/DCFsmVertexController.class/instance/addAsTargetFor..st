adding
addAsTargetFor: aController
	| newModel newFigure |
	self assert: (self canBeTargetFor: aController).
	aController target: self.
	aController diagramController: self diagramController.
	newModel := aController createModel.
	self diagramController model add: newModel.
	aController model: newModel.
	self diagramController controllers add: aController.
	newFigure := aController figure.
	newFigure view ifNil: [ self diagramController view add: newFigure ].
	self diagramController figureAdded: newFigure