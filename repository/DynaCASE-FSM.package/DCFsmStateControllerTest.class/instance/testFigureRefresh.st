tests
testFigureRefresh
	| ctrl |
	ctrl := self createController.
	ctrl model: ctrl createModel.
	ctrl figure: (ctrl createFigure renderIn: view).
	self assert: (ctrl figure attributeAt: #RTLabelledLabel) text = ''.
	ctrl model name: 'new name'.
	ctrl refreshFigure.
	self assert: (ctrl figure attributeAt: #RTLabelledLabel) text = 'new name'