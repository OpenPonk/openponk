tests
testMoveAlongEdge
	DCRTEdgeAlongConstraint move: shape1 alongEdge: edge offset: 0.
	self assert: shape1 position = ((box1 position + box2 position) * 0.5).

	DCRTEdgeAlongConstraint
		move: shape1
		alongEdge: edge
		balance: 1
		offset: 10.
	self assert: shape1 position = (box2 position + (0 @ 10)).

	DCRTEdgeAlongConstraint
		move: shape1
		alongEdge: edge
		balance: 0
		offset: 0.
	self assert: shape1 position = box1 position.

	DCRTEdgeAlongConstraint
		move: shape1
		alongEdge: edge
		balance: -0.5
		offset: -10.
	self assert: shape1 position = (-50 @ -10)