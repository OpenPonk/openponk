positioning
moveBy: aVector from: aNeighbor
	self basicMoveBy: aVector.
	self removeIfNecessary