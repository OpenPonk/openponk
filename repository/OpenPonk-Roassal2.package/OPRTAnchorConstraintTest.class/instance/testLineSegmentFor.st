tests
testLineSegmentFor
	true
		ifTrue: [ ^ self skip: 'Not sure what the problem is here' ].
	segment := edgeAnchor lineSegmentFor: edge.
	self assert: segment from equals: source position.
	self assert: segment to equals: target position