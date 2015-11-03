tests
testIndexPositions
	| positions |
	positions := layout removeFeatureOverlapsFor: label positions: self initialPositions.
	positions := (layout indexPositions: {(label -> positions)} asDictionary) at: label.
	self assertPosition: positions first model equals: self initialPositions first.
	self assert: positions first index equals: 1.
	self assertPosition: positions second model equals: self initialPositions second.
	self assert: positions second index equals: 2