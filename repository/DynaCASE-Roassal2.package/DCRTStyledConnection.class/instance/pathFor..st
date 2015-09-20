rendering
pathFor: anEdge
	| fromPoint toPoint |
	(anEdge from = anEdge to and: [ self points isEmpty ])
		ifTrue: [ self createLineToSelfFor: anEdge ].
	fromPoint := attachPoint startingPointOf: anEdge.
	toPoint := attachPoint endingPointOf: anEdge.
	^ {fromPoint} , self points , {toPoint}