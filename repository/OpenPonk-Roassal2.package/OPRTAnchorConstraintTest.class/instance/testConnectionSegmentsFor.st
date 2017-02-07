tests
testConnectionSegmentsFor
	| segments |
	expected := {(RTLineSegment from: 0 @ (source height / 2) to: 0 @ 50).
	(RTLineSegment from: 0 @ 50 to: 50 @ 100).
	(RTLineSegment from: 50 @ 100 to: (100 - (target width / 2)) @ 100)}.
	segments := connectionAnchor connectionSegmentsFor: connection.
	self assert: segments equals: expected.
	self assert: connectionAnchor segments segments equals: expected