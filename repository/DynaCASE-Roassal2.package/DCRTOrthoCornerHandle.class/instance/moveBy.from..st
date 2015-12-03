positioning
moveBy: aVector from: aNeighbor
	(aNeighbor position - self position) abs < (2 @ 2)
		ifTrue: [ self basicMoveTo: aNeighbor position.
			^ self remove ].
	self basicMoveBy: aVector.
	self removeIfNecessary