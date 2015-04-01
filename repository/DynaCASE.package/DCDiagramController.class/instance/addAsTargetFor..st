adding
addAsTargetFor: aController
	| newModel newFigure |
	self assert: (self canBeTargetFor: aController).
	newModel := aController createModel.
	self model add: newModel.
	aController
		diagramController: self diagramController;
		model: newModel.
	self diagramController controllers add: aController.
	newFigure := aController figure.
	newFigure view ifNil: [ self view add: newFigure ].
	figureAdded value: newFigure.
	aController refreshFigure.
	self view signalUpdate