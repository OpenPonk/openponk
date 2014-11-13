as yet unclassified
testMoveNearOriginOfEdge
	DCRTEdgeEndConstraint
		move: shape1
		nearStartOfEdge: edge
		distance: 0
		offset: 0.
	self assert: shape1 position = box1 position.
	DCRTEdgeEndConstraint
		move: shape1
		nearStartOfEdge:  edge
		distance: 30
		offset: 10.
	self assert: shape1 position = (box1 position + (30 @ 10)).
	DCRTEdgeEndConstraint
		move: shape1
		nearStartOfEdge:  edge
		distance: -10
		offset: -10.
	self assert: shape1 position = (box1 position + (-10 @ -10)).
	DCRTEdgeEndConstraint
		move: shape1
		nearEndOfEdge:  edge
		distance: 30
		offset: 10.
	self assert: shape1 position = (box2 position + (-30 @ 10))