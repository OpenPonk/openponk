tests
testStraightLine
	builder
		addSource: e1;
		addTarget: e2.
	self assert: (builder center onLineFrom: e1 position to: e2 position)