tests
testInitialPositions
	| positions |
	layout spacing: 50.
	positions := layout initialPositionsFor: label.
	self assert: positions size equals: 12.
	self assertPosition: positions first equals: self initialPositions first.
	self assertPosition: positions second equals: self initialPositions second.
	self assertPosition: positions third equals: self initialPositions third.
	self assertPosition: positions fourth equals: self initialPositions fourth