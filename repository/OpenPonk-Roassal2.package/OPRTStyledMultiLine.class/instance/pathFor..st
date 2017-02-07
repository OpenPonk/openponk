accessing
pathFor: anEdge
	| fromPoint toPoint |
	self checkLineToSelfFor: anEdge.
	fromPoint := attachPoint startingPointOf: anEdge.
	toPoint := attachPoint endingPointOf: anEdge.
	^ blockProducingPath value: fromPoint value: toPoint