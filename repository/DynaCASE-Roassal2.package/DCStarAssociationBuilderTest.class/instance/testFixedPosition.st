tests
testFixedPosition
	builder
		addSource: e1;
		addTarget: e2.
	self assert: builder center = ((e1 position + e2 position) / 2).
	builder translateTo: 500 @ 50.
	self assert: builder center = (500 @ 50).
	builder translateBy: -100 @ -50.
	self assert: builder position = (400 @ 0).
	builder dynamicCentering.
	self assert: builder center = ((e1 position + e2 position) / 2)