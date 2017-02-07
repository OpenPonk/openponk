public - hooks
startingPointOf: anEdge
	^ (super startingPointOf: anEdge) - (0 @ (self offsetDistanceFor: anEdge))