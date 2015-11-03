tests
testRemoveFeatureOverlaps
	| positions |
	positions := layout removeFeatureOverlapsFor: label positions: self initialPositions.
	self assert: positions size equals: 2.
	self assertPosition: positions first equals: self initialPositions first.
	self assertPosition: positions second equals: self initialPositions second