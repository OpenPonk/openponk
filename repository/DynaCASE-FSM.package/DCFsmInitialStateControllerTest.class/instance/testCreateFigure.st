tests
testCreateFigure
	super testCreateFigure.
	self assert: figure element shape class equals: RTEllipse.
	self assert: figure element color equals: Color black.
	self assert: figure element extent equals: 14 @ 14