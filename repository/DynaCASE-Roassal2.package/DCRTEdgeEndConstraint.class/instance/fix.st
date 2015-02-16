running
fix
	"a little math... reverse process of move: gets settings according to shape and edge positions"

	| startPoint endPoint originPoint nearestPoint edgeVector positionVector |
	startPoint := edge shape startingPointOf: edge.
	endPoint := edge shape endingPointOf: edge.
	originPoint := origin = #start
		ifTrue: [ startPoint ]
		ifFalse: [ endPoint ].
	nearestPoint := shape position nearestPointAlongLineFrom: startPoint to: endPoint.
	edgeVector := endPoint - startPoint.
	positionVector := shape position - nearestPoint.
	offset := shape position dist: nearestPoint.
	(edgeVector + positionVector rightRotated) r > edgeVector r
		ifTrue: [ offset := offset negated ].
	distance := nearestPoint dist: originPoint.
	(shape position nearestPointOnLineFrom: startPoint to: endPoint) = originPoint
		ifTrue: [ distance := distance negated ].
	self stick