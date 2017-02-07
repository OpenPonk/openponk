positioning
constraintVector: aVector for: aNeighbor
	^ self position y - aVector y = aNeighbor position y
		ifTrue: [ 0 @ aVector y ]
		ifFalse: [ aVector x @ 0 ]