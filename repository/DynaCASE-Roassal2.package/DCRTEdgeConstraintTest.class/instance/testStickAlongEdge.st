as yet unclassified
testStickAlongEdge
	"mousedrag events are not tested (yet)"

	DCRTEdgeConstraint stick: shape1 alongEdge: edge offset: 0.
	DCRTEdgeConstraint
		stick: shape2
		alongEdge: edge
		balance: 0
		offset: 10.
	DCRTEdgeConstraint
		stick: shape3
		alongEdge: edge
		balance: -0.5
		offset: -10.
	self assert: shape1 position = ((box1 position + box2 position) * 0.5).
	self assert: shape2 position = (box1 position + (0 @ 10)).
	self assert: shape3 position = (-50 @ -10).
	box2 translateTo: box1 position - (0 @ 100).
	self assert: shape1 position = ((box1 position + box2 position) * 0.5).
	self assert: shape2 position = (box1 position + (10 @ 0)).
	self assert: shape3 position = (box1 position + (-10 @ 50)).
	box2 translateTo: box1 position