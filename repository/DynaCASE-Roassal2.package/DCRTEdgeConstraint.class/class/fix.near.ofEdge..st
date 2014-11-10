public - sticking
fix: aShape near: origin ofEdge: anEdge
	"example: DCRTEdgeConstraint fix: RTBox new near: #start ofEdge: RTEdge new"

	| startPoint endPoint originPoint nearestPoint edgeVector positionVector offset distance |
	startPoint := anEdge shape startingPointOf: anEdge.
	endPoint := anEdge shape endingPointOf: anEdge.
	originPoint := origin = #start
		ifTrue: [ startPoint ]
		ifFalse: [ endPoint ].
	nearestPoint := aShape position nearestPointAlongLineFrom: startPoint to: endPoint.
	edgeVector := endPoint - startPoint.
	positionVector := aShape position - nearestPoint.
	offset := aShape position dist: nearestPoint.
	(edgeVector + positionVector rightRotated) r > edgeVector r
		ifTrue: [ offset := offset negated ].
	distance := nearestPoint dist: originPoint.
	(aShape position nearestPointOnLineFrom: startPoint to: endPoint) = originPoint
		ifTrue: [ distance := distance negated ].
	self
		stick: aShape
		near: origin
		ofEdge: anEdge
		distance: distance
		offset: offset