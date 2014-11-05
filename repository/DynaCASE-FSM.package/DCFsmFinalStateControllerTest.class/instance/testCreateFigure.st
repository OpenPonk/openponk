tests
testCreateFigure
	| ctrl figure |
	ctrl := self createController.
	figure := ctrl createFigure renderIn: view.
	self assert: view elements size = 1.
	self assert: figure class = RTElement.
	self assert: figure shape class = DCRoassalSmFinalState.
	self assert: figure color = Color transparent.
	self assert: figure extent = (40 @ 40)