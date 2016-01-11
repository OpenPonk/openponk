tests
testFigureRefresh
	| label |
	fromCtrl figure: (self renderFigureOf: fromCtrl).
	toCtrl figure: (self renderFigureOf: toCtrl).
	ctrl
		source: fromCtrl;
		target: toCtrl;
		model: ctrl createModel;
		figure: self renderFigure.
	label := ctrl figure labels at: #name.
	self assert: label trachelShape text equals: ''.
	ctrl model name: 'new name'.
	ctrl refreshFigure.
	self assert: label trachelShape text equals: 'new name'