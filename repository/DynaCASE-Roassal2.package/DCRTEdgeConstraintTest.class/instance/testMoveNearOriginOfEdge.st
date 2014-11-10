as yet unclassified
testMoveNearOriginOfEdge
	DCRTEdgeConstraint
		move: shape1
		near: #start
		ofEdge: edge
		distance: 0
		offset: 0.
	self assert: shape1 position = box1 position.
	DCRTEdgeConstraint
		move: shape1
		near: #start
		ofEdge: edge
		distance: 30
		offset: 10.
	self assert: shape1 position = (box1 position + (30 @ 10)).
	DCRTEdgeConstraint
		move: shape1
		near: #start
		ofEdge: edge
		distance: -10
		offset: -10.
	self assert: shape1 position = (box1 position + (-10 @ -10)).
	DCRTEdgeConstraint
		move: shape1
		near: #end
		ofEdge: edge
		distance: 30
		offset: 10.
	self assert: shape1 position = (box2 position + (-30 @ 10))