tests
testCreateFigure
	self class = DCFsmVertexControllerTest
		ifTrue: [ ^ self ].
	self renderFigure.
	self assert: view elements size = 1.
	self assert: figure class = RTElement