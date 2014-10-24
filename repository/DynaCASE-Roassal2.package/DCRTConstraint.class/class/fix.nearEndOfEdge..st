public - sticking
fix: aShape nearEndOfEdge: anEdge
	| edgeVector positionVector startPoint endPoint nearestPoint offset distance |
	startPoint := anEdge shape startingPointOf: anEdge.
	endPoint := anEdge shape endingPointOf: anEdge.
	nearestPoint := aShape position nearestPointAlongLineFrom: startPoint to: endPoint.
	edgeVector := endPoint - startPoint.
	positionVector := aShape position - nearestPoint.
	offset := aShape position dist: nearestPoint.
	(edgeVector + positionVector rightRotated) r > edgeVector r
		ifTrue: [ offset := offset negated ].
	distance := nearestPoint dist: endPoint.
	(aShape position nearestPointOnLineFrom: startPoint to: endPoint) = endPoint
		ifTrue: [ distance := distance negated ].
	self
		stick: aShape
		nearEndOfEdge: anEdge
		distance: distance
		offset: offset