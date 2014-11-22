hooks
updateFor: anEdge trachelShape: trachelShape from: aPoint
	self
		updateFor: anEdge
		trachelShape: trachelShape
		from: aPoint
		to:
			(tail
				ifFalse: [ attachPoint endingPointOf: anEdge ]
				ifTrue: [ attachPoint startingPointOf: anEdge ])