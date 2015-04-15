public
trachelShapeFor: anEdge from: aPoint
	^ self trachelShapeFor: anEdge from: aPoint to: (attachPoint startingPointOf: anEdge)