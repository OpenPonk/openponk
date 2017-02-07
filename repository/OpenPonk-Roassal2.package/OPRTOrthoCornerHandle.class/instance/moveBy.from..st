positioning
moveBy: aVector from: aNeighbor
	self basicMoveBy: aVector.
	aNeighbor position = self position
		ifTrue: [ self remove.
			^ self removeIfNecessary: aNeighbor ].
	self removeIfNecessary