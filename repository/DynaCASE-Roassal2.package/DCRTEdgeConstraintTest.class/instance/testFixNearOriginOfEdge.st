as yet unclassified
testFixNearOriginOfEdge
	"mousedrag events are not tested (yet)"

	DCRTEdgeEndConstraint fix: shape1 near: #start ofEdge: edge.
	DCRTEdgeEndConstraint fix: shape2 near: #start ofEdge: edge.
	DCRTEdgeEndConstraint fix: shape3 near: #end ofEdge: edge.
	self assert: shape1 position = (50 @ 0).
	self assert: shape2 position = (0 @ 10).
	self assert: shape3 position = (-50 @ -10).
	box2 translateTo: box1 position - (0 @ 1000).
	self assert: shape1 position = (0 @ -50).
	self assert: shape2 position = (10 @ 0).
	self assert: shape3 position = (-10 @ -850).
	box2 translateTo: box1 position