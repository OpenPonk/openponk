propagation
propagate: aVector from: aNeighborHandle
	self neighbors reject: [ :each | each = aNeighborHandle ] thenDo: [ :each |
		each neighbor: self hasMovedBy: aVector
	]