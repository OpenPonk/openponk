public
trachelShapeFor: anEdge
	| fromPoint |
	fromPoint := self sourcePointOf: anEdge.
	line
		ifNotNil: [ 
			| lineShape |
			lineShape := line trachelShapeFor: anEdge.
			lineShape class = TRBezierShape
				ifTrue: [ fromPoint := self sourcePointOfBezier: lineShape ] ].
	^ self trachelShapeFor: anEdge from: fromPoint