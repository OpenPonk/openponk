geometry
vertexInducedBy: aVertexSet
	^ self class new
		nodes: aVertexSet;
		edges: (self edgesForAll: aVertexSet);
		yourself