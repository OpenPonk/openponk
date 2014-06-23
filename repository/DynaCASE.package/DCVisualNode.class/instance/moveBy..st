path commands
moveBy: aVector
	self position: self position + aVector.
	self container subnodeMoved: aVector.