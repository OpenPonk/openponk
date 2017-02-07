rendering
updateFor: anEdge trachelShape: trachelShape
	| from |
	self updateArcFor: anEdge trachelShape: trachelShape shapes first.
	from := 6 @ 0 + (trachelShape shapes first arc circle tangentAt: (attachPoint endingPointOf: anEdge)).
	head updateFor: anEdge trachelShape: (trachelShape shapes atLast: 2) from: from.
	tail updateFor: anEdge trachelShape: trachelShape shapes last