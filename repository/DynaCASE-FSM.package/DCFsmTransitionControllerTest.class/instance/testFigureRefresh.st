tests
testFigureRefresh
	| ctrl fromCtrl toCtrl label |
	ctrl := self createController.
	fromCtrl := DCFsmInitialStateController new.
	fromCtrl figure: (fromCtrl createFigure renderIn: view).
	toCtrl := DCFsmFinalStateController new.
	toCtrl figure: (toCtrl createFigure renderIn: view).
	ctrl source: fromCtrl.
	ctrl target: toCtrl.
	ctrl model: ctrl createModel.
	ctrl figure: (ctrl createFigure renderIn: view).
	label := ctrl figure labels first.
	self assert: label trachelShape text = ''.
	ctrl model name: 'new name'.
	ctrl refreshFigure.
	self assert: label trachelShape text = 'new name'