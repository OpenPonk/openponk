tests
testFigureRefresh
	self skip.
	ctrl model: ctrl createModel.
	ctrl figure: self renderFigure.
	self assert: (ctrl figure attributeAt: #RTLabelledLabel) text = ''.

	ctrl model name: 'new name'.
	ctrl refreshFigure.
	self assert: (ctrl figure attributeAt: #RTLabelledLabel) text = 'new name'