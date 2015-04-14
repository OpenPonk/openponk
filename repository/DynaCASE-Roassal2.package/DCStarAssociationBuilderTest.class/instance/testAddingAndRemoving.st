tests
testAddingAndRemoving
	self
		assert: builder sources isEmpty;
		assert: builder targets isEmpty;
		assert: builder elements isEmpty;
		assert: builder edges size = builder elements size.

	builder addSource: e1.
	self
		assert: builder sources size = 1;
		assert: builder targets isEmpty;
		assert: builder elements size = 1;
		assert: builder edges size = builder elements size.

	builder addTarget: e2.
	self
		assert: builder sources size = 1;
		assert: builder targets size = 1;
		assert: builder elements size = 2;
		assert: builder edges size = builder elements size.

	builder removeElement: e2.
	self
		assert: builder sources size = 1;
		assert: builder targets isEmpty;
		assert: builder elements size = 1;
		assert: builder edges size = builder elements size.

	builder addTarget: e1.
	self
		assert: builder sources size = 1;
		assert: builder targets isEmpty;
		assert: builder elements size = 1;
		assert: builder edges size = builder elements size.

	builder removeEdge: e1 connectedEdges anyOne.
	self
		assert: builder sources isEmpty;
		assert: builder targets isEmpty;
		assert: builder elements isEmpty;
		assert: builder edges size = builder elements size