tests
testTargetsOnly
	builder
		addTarget: e1;
		addTarget: e2;
		addTarget: e3.
	self assert: (builder center closeTo: (e1 position + e2 position + e3 position) / 3)