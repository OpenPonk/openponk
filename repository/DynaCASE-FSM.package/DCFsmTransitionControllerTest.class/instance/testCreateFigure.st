tests
testCreateFigure
	| figure |
	fromCtrl figure: (self renderFigureOf: fromCtrl).
	toCtrl figure: (self renderFigureOf: toCtrl).
	ctrl
		source: fromCtrl;
		target: toCtrl.
	figure := self renderFigure.

	self assert: figure class = RTEdge.
	self assert: figure from = fromCtrl figure.
	self assert: figure to = toCtrl figure.
	self assert: view elements size = 3.
	self assert: figure shape class = DCRTMultiLine.
	self assert: figure shape color = Color black.
	self assert: figure shape head shape = DCRTSimpleArrow.
	self assert: figure shape dashes isNil