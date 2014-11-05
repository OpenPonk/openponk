tests
testCreateFigure
	| ctrl figure |
	ctrl := self createController.
	figure := ctrl createFigure renderIn: view.
	self assert: figure class = RTElement.
	self assert: figure shape class = RTEllipse.
	self assert: figure color = Color black.
	self assert: figure extent = (14 @ 14).
	self assert: view elements size = 1