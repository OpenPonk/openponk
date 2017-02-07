positioning
moveBy: aVector from: aNeighbor
	| targetPosition |
	targetPosition := self position + aVector.
	(self isInsideEndElement: targetPosition)
		ifTrue: [ ^ self basicMoveBy: aVector ].
	self
		basicMoveTo:
			((RTLineSegment from: self position to: targetPosition)
				intersectRectangle: endElement encompassingRectangle) anyOne.
	self newCornerAt: targetPosition