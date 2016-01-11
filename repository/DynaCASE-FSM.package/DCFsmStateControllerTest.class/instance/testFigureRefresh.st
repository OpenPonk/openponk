tests
testFigureRefresh
	ctrl model: ctrl createModel.
	ctrl figure: self renderFigure.
	self assert: ctrl figure model label model equals: ''.
	ctrl model name: 'new name'.
	ctrl refreshFigure.
	self assert: ctrl figure model label model equals: 'new name'