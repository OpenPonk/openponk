private 
doFix: aShape nearPoint: aPoint ofEdge: anEdge using: aBlock
	| startPoint endPoint nearestPoint edgeVector positionVector offset distance |
	startPoint := anEdge shape startingPointOf: anEdge.
	endPoint := anEdge shape endingPointOf: anEdge.
	nearestPoint := aShape position nearestPointAlongLineFrom: startPoint to: endPoint.
	edgeVector := endPoint - startPoint.
	positionVector := aShape position - nearestPoint.
	offset := aShape position dist: nearestPoint.
	(edgeVector + positionVector rightRotated) r > edgeVector r
		ifTrue: [ offset := offset negated ].
	distance := nearestPoint dist: aPoint.
	(aShape position nearestPointOnLineFrom: startPoint to: endPoint) = aPoint
		ifTrue: [ distance := distance negated ].
	aBlock value: distance value: offset