positioning
constraintVector: aVector for: aNeighbor
	^ (aNeighbor position y roundTo: 1) = (self position y roundTo: 1)
		ifTrue: [ 0 @ aVector y ]
		ifFalse: [ aVector x @ 0 ]