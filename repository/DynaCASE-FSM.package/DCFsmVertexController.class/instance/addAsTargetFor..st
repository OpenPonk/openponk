adding
addAsTargetFor: aController
	| newModel viewElement |
	self assert: (self canBeTargetFor: aController).
	aController target: self.
	aController parent: self parent.
	newModel := aController createModel.
	self parent model add: newModel.
	aController model: newModel.
	self parent controllers add: aController.
	viewElement := aController view.
	viewElement view ifNil: [ self view add: viewElement ].
	self parent figureAdded: viewElement