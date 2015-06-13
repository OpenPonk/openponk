tests
testCreateFigure
	self skip.
	super testCreateFigure.
	self assert: figure shape class = DCRoassalSmFinalState.
	self assert: figure color = Color transparent.
	self assert: figure extent = (40 @ 40)