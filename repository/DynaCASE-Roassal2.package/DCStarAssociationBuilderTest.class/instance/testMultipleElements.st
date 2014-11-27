tests
testMultipleElements
	builder
		addSource: e1;
		addSource: e2;
		addTarget: e3;
		addTarget: e4;
		addTarget: e5.
	self
		assert:
			(builder center closeTo: ((e1 position + e2 position) / 2 + ((e3 position + e4 position + e5 position) / 3)) / 2)