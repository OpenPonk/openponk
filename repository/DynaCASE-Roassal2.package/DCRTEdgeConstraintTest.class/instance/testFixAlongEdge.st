as yet unclassified
testFixAlongEdge
	"mousedrag events are not tested (yet)"

	DCRTEdgeConstraint fix: shape1 alongEdge: edge.
	DCRTEdgeConstraint fix: shape2 alongEdge: edge.
	DCRTEdgeConstraint fix: shape3 alongEdge: edge.
	self assert: shape1 position = (50 @ 0).
	self assert: shape2 position = (0 @ 10).
	self assert: shape3 position = (-50 @ -10).
	box2 translateTo: box1 position - (0 @ 1000).
	self assert: shape1 position = (0 @ -500).
	self assert: shape2 position = (10 @ 0).
	self assert: shape3 position = (-10 @ 500).
	box2 translateTo: box1 position