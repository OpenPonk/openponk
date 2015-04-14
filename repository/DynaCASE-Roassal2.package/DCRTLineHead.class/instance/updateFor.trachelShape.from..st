hooks
updateFor: anEdge trachelShape: trachelShape from: aPoint
	self
		updateFor: anEdge
		trachelShape: trachelShape
		from: aPoint
		to: (attachPoint endingPointOf: anEdge)