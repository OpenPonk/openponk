propagation
neighbor: aHandle hasMovedBy: aVector
	| next previous |
	next := self next next.
	(next isAnchor and: [ (next anchoredElement encompassingRectangle expandBy: 5) containsPoint: self position ])
		ifTrue: [ ^ next removeLastSegment ].
	previous := self previous previous.
	(previous isAnchor and: [ (previous anchoredElement encompassingRectangle expandBy: 5) containsPoint: self position ])
		ifTrue: [ ^ previous removeFirstSegment ].
	self constrainedMoveBy: aVector.
	self propagate: aVector from: aHandle