tests
testCreateFigure
	super testCreateFigure.
	self assert: figure shape class = RTEllipse.
	self assert: figure color = Color black.
	self assert: figure extent = (14 @ 14)