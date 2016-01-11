tests
testCreateFigure
	self class = DCFsmVertexControllerTest
		ifTrue: [ ^ self ].
	self renderFigure.
	self assert: view elements size equals: 1.
	self assert: figure class equals: DCFsmInitialStateFigure