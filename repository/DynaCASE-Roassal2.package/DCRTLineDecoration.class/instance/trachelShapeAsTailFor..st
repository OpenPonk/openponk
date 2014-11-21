as yet unclassified
trachelShapeAsTailFor: anEdge
	| t shape |
	t := attachPoint endingPointOf: anEdge.
	line ~= nil
		ifTrue: [ 
			| tShape |
			tShape := line trachelShapeFor: anEdge.
			tShape class = TRBezierShape
				ifTrue: [ t := tShape points second ] ].
	shape := self trachelShapeClass
		from: (attachPoint startingPointOf: anEdge)
		to: t
		width: (self widthFor: anEdge)
		size: (self mySize rtValue: anEdge)
		color: (self colorFor: anEdge)
		stroke: (self colorFor: anEdge).
	shape baseSize: (baseSize rtValue: anEdge).
	^ shape