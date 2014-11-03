adding
addAsTargetFor: aController
	| newModel viewElement |
	self assert: (self canBeTargetFor: aController).
	newModel := aController createModel.
	self model add: newModel.
	aController
		parent: self;
		model: newModel.
	self controllers add: aController.
	viewElement := aController view.
	viewElement view ifNil: [ self view add: viewElement ].
	figureAdded value: viewElement.
	self view signalUpdate