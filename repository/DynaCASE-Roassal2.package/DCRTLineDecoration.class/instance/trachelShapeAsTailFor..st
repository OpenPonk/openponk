private
trachelShapeAsTailFor: anEdge
	| f shape |
	f := attachPoint endingPointOf: anEdge.
	line
		ifNotNil: [ 
			| tShape |
			tShape := line trachelShapeFor: anEdge.
			tShape class = TRBezierShape
				ifTrue: [ f := tShape points second ] ].
	shape := self trachelShapeClass
		from: f
		to: (attachPoint startingPointOf: anEdge)
		width: (self widthFor: anEdge)
		size: (self mySize rtValue: anEdge)
		color: (self colorFor: anEdge)
		stroke: (self colorFor: anEdge).
	shape baseSize: (baseSize rtValue: anEdge).
	^ shape