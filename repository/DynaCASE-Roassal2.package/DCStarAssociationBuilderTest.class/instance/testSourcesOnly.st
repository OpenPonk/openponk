tests
testSourcesOnly
	builder
		addSource: e1;
		addSource: e2;
		addSource: e3.
	self assert: (builder center closeTo: (e1 position + e2 position + e3 position) / 3)