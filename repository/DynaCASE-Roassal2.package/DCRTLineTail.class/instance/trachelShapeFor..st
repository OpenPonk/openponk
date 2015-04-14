public
trachelShapeFor: anEdge
	| fromPoint |
	fromPoint := attachPoint endingPointOf: anEdge.
	line
		ifNotNil: [ 
			| lineShape |
			lineShape := line trachelShapeFor: anEdge.
			lineShape class = TRBezierShape
				ifTrue: [ fromPoint := lineShape points second ] ].
	^ self trachelShapeFor: anEdge from: fromPoint