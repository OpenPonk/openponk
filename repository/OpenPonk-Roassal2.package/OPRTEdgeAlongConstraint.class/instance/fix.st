running
fix
	"a little math... reverse process of move: gets settings according to shape and edge positions"

	| startPoint endPoint nearestPoint edgeVector nearestPointVector positionVector edgeVectorR |
	startPoint := edge shape startingPointOf: edge.
	endPoint := edge shape endingPointOf: edge.
	edgeVector := endPoint - startPoint.
	nearestPoint := shape position nearestPointAlongLineFrom: startPoint to: endPoint.
	positionVector := shape position - nearestPoint.
	edgeVectorR := edgeVector r.
	offset := shape position dist: nearestPoint.
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
	self stick