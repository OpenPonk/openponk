adding
addAsTargetFor: aController
	| newModel newFigure |
	self assert: (self canBeTargetFor: aController).
	aController target: self.
	aController parent: self parent.
	newModel := aController createModel.
	self parent model add: newModel.
	aController model: newModel.
	self parent controllers add: aController.
	newFigure := aController figure.
	newFigure view ifNil: [ self parent view add: newFigure ].
	self parent figureAdded: newFigure