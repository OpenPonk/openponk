propagation
neighbor: aHandle hasMovedBy: aVector
	self constrainedMoveBy: aVector.
	self propagate: aVector from: aHandle