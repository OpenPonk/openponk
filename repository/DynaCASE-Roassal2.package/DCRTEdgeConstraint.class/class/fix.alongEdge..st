public - sticking
fix: aShape alongEdge: anEdge
	| startPoint endPoint nearestPoint edgeVector nearestPointVector positionVector edgeVectorR balance offset |
	startPoint := anEdge shape startingPointOf: anEdge.
	endPoint := anEdge shape endingPointOf: anEdge.
	edgeVector := endPoint - startPoint.
	nearestPoint := aShape position nearestPointAlongLineFrom: startPoint to: endPoint.
	positionVector := aShape position - nearestPoint.
	edgeVectorR := edgeVector r.
	offset := aShape position dist: nearestPoint.
	(edgeVector + positionVector rightRotated) r > edgeVectorR
		ifTrue: [ offset := offset negated ].
	edgeVectorR < 5
		ifTrue: [ balance := 0.5 ]
		ifFalse: [ 
			nearestPointVector := nearestPoint - startPoint.
			edgeVector x = 0
				ifTrue: [ balance := nearestPointVector y / edgeVector y ]
				ifFalse: [ 
					edgeVector y = 0
						ifTrue: [ balance := nearestPointVector x / edgeVector x ]
						ifFalse: [ balance := nearestPointVector / edgeVector ] ] ].
	self
		stick: aShape
		alongEdge: anEdge
		balance: balance
		offset: offset