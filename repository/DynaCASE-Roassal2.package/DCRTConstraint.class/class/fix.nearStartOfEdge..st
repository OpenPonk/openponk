public - sticking
fix: aShape nearStartOfEdge: anEdge
	| edgeVector positionVector startPoint endPoint nearestPoint offset distance |
	startPoint := anEdge shape startingPointOf: anEdge.
	endPoint := anEdge shape endingPointOf: anEdge.
	nearestPoint := aShape position nearestPointAlongLineFrom: startPoint to: endPoint.
	edgeVector := endPoint - startPoint.
	positionVector := aShape position - nearestPoint.
	offset := aShape position dist: nearestPoint.
	(edgeVector + positionVector rightRotated) r > edgeVector r
		ifTrue: [ offset := offset negated ].
	distance := nearestPoint dist: startPoint.
	(aShape position nearestPointOnLineFrom: startPoint to: endPoint) = startPoint
		ifTrue: [ distance := distance negated ].
	self
		stick: aShape
		nearStartOfEdge: anEdge
		distance: distance
		offset: offset