public
trachelShapeFor: anEdge
	| fromPoint |
	fromPoint := attachPoint startingPointOf: anEdge.
	line
		ifNotNil: [ 
			| lineShape |
			lineShape := line trachelShapeFor: anEdge.
			lineShape class = TRBezierShape
				ifTrue: [ fromPoint := lineShape points allButLast last ] ].
	^ self trachelShapeFor: anEdge from: fromPoint