as yet unclassified
removeNeighborCorner
	self hasSuccessor
		ifTrue:
			[ self
				moveToBorder: (RTLineSegment from: self nextLink position to: self nextLink nextLink position).
			self nextLink remove ]
		ifFalse:
			[ self
				moveToBorder: (RTLineSegment from: self previousLink position to: self previousLink previousLink position).
			self previousLink remove ]