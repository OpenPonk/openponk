tests
testCreateFigure
	| figure |
	fromCtrl figure: (self renderFigureOf: fromCtrl).
	toCtrl figure: (self renderFigureOf: toCtrl).
	ctrl
		source: fromCtrl;
		target: toCtrl.
	figure := self renderFigure.
	self assert: figure class equals: RTEdge.
	self assert: figure from equals: fromCtrl figure.
	self assert: figure to equals: toCtrl figure.
	self assert: view elements size equals: 4.
	self assert: figure shape class equals: DCRTStyledMultiLine.
	self assert: figure shape color equals: Color black.
	self assert: figure shape head shape equals: RTSimpleArrow.
	self assert: figure shape dashes isNil