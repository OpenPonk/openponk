public - hooks
endingPointOf: anEdge
	^ (super endingPointOf: anEdge) - ((self offsetDistanceFor: anEdge) @ 0)