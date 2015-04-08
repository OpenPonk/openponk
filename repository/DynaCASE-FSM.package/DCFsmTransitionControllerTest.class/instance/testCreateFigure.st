tests
testCreateFigure
	| ctrl figure fromCtrl toCtrl |
	ctrl := self createController.
	fromCtrl := DCFsmInitialStateController new.
	fromCtrl figure: (fromCtrl createFigure renderIn: view).
	toCtrl := DCFsmFinalStateController new.
	toCtrl figure: (toCtrl createFigure renderIn: view).
	ctrl source: fromCtrl.
	ctrl target: toCtrl.
	figure := ctrl createFigure renderIn: view.
	self assert: figure class = RTEdge.
	self assert: figure from = fromCtrl figure.
	self assert: figure to = toCtrl figure.
	self assert: view elements size = 3.
	self assert: figure shape class = DCRTMultiLine.
	self assert: figure shape color = Color black.
	self assert: figure shape head shape = DCRTSimpleArrow.
	self assert: figure shape dashes isNil