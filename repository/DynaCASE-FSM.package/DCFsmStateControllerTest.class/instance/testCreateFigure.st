tests
testCreateFigure
	super testCreateFigure.
	self assert: figure class = RTElement.
	self assert: figure shape class = RTEllipse.
	self assert: figure color = Color transparent.
	self assert: figure extent = (40 @ 40)