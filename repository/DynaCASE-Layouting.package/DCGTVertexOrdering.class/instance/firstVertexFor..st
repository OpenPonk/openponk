as yet unclassified
firstVertexFor: aGraph
	| minDeg |
	minDeg := (aGraph nodes collect: #inDegree) min.
	^ (aGraph nodes select: [ :each | each inDegree = minDeg ]) detectMin: #outDegree