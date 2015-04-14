tests
testFixNearOriginOfEdge
	"mousedrag events are not tested (yet)"

	DCRTEdgeEndConstraint
		fix: shape1 nearStartOfEdge: edge;
		fix: shape2 nearStartOfEdge: edge;
		fix: shape3 nearEndOfEdge: edge.

	self assert: shape1 position = (50 @ 0).
	self assert: shape2 position = (0 @ 10).
	self assert: shape3 position = (-50 @ -10).

	box2 translateTo: box1 position - (0 @ 1000).
	self assert: shape1 position = (0 @ -50).
	self assert: shape2 position = (10 @ 0).
	self assert: shape3 position = (-10 @ -850).

	self shouldnt: [ box2 translateTo: box1 position ] raise: ZeroDivide