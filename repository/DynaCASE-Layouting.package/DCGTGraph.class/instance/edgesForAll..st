geometry
edgesForAll: aVertexSet
	^ self edges
		select: [ :each | (aVertexSet includes: each from) and: [ aVertexSet includes: each to ] ]