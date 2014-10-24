public - sticking
fix: aShape alongEdge: anEdge
	| edgeVector nearestPointVector startPoint endPoint nearestPoint offset positionVector |
	startPoint := anEdge shape startingPointOf: anEdge.
	endPoint := anEdge shape endingPointOf: anEdge.
	edgeVector := endPoint - startPoint.
	edgeVector isZero
		ifTrue: [ edgeVector := 1 @ 1 ].
	nearestPoint := aShape position nearestPointAlongLineFrom: startPoint to: endPoint.
	nearestPointVector := nearestPoint - startPoint.
	positionVector := aShape position - nearestPoint.
	offset := aShape position dist: nearestPoint.
	(edgeVector + positionVector rightRotated) r > edgeVector r
		ifTrue: [ offset := offset negated ].
	self
		stick: aShape
		alongLine: anEdge
		balance: nearestPointVector / edgeVector
		offset: offset