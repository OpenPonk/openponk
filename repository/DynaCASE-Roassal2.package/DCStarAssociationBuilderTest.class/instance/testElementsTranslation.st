tests
testElementsTranslation
	builder
		addSource: e1;
		addTarget: e2.
	self assert: builder center = ((e1 position + e2 position) / 2).

	e2 translateTo: 500 @ 50.
	self assert: builder center = ((e1 position + e2 position) / 2).

	e1 translateTo: -50 @ 50.
	self assert: builder center = ((e1 position + e2 position) / 2)