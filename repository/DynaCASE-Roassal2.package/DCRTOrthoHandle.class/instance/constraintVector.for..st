positioning
constraintVector: aVector for: aNeighbor
	| diff |
	diff := (aNeighbor position - self position) abs.
	diff < (1 @ 1)
		ifTrue: [ ^ 0 @ 0 ].
	^ diff x > diff y
		ifTrue: [ 0 @ aVector y ]
		ifFalse: [ aVector x @ 0 ]