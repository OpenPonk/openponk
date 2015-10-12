tests
testLineSegmentFor
	segment := edgeAnchor lineSegmentFor: edge.
	self assert: segment from equals: source position.
	self assert: segment to equals: target position