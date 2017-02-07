rendering
pathFor: anEdge
	| fromPoint toPoint |
	fromPoint := attachPoint startingPointOf: anEdge.
	toPoint := attachPoint endingPointOf: anEdge.
	^ {fromPoint} , self points , {toPoint}