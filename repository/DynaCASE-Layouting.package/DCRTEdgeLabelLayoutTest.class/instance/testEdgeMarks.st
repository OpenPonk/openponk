tests
testEdgeMarks
	| marks |
	layout spacing: 30.
	marks := layout edgeMarksFor: edge.
	self
		assert: marks
		equals:
			{(25 @ 0).
			(40 @ 0).
			(70 @ 0).
			(75 @ 0)}