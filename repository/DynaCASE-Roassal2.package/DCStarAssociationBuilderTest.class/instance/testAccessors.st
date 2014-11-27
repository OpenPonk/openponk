tests
testAccessors
	| builderEdges trueEdges |
	builder
		addSource: e1;
		addSource: e2;
		addTarget: e3;
		addTarget: e4;
		addTarget: e5.
	self
		assert: (e1 connectedEdges includes: (builder edgeOf: e1));
		assert: (e5 connectedEdges includes: (builder edgeOf: e5)).
	builderEdges := builder edges asBag.
	trueEdges := ((((e1 connectedEdges union: e2 connectedEdges) union: e3 connectedEdges) union: e4 connectedEdges)
		union: e5 connectedEdges) asBag.
	self assert: builderEdges = trueEdges