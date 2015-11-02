tests
testEdgeMarks
	| marks |
	layout spacing: 10.
	marks := layout edgeMarksFor: edge.
	self
		assertCollection: marks
		hasSameElements: ((10 to: 90 by: 10) collect: [ :each | each @ 0 ])