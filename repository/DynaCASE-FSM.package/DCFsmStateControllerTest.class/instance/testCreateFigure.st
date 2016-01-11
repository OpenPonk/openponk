tests
testCreateFigure
	self renderFigure.
	self assert: view elements size equals: 2.
	self assert: figure class equals: DCFsmStateFigure.
	self assert: figure element class equals: RTElement.
	self assert: figure element shape class equals: RTRoundedBox.
	self assert: figure element color equals: Color transparent.
	self assert: figure element extent equals: 50 @ 50