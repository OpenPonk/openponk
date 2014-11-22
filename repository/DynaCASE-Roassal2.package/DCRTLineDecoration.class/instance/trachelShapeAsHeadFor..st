private
trachelShapeAsHeadFor: anEdge
	| f shape |
	f := attachPoint startingPointOf: anEdge.
	line
		ifNotNil: [ 
			| tShape |
			tShape := line trachelShapeFor: anEdge.
			tShape class = TRBezierShape
				ifTrue: [ f := tShape points allButLast last ] ].
	shape := self trachelShapeClass
		from: f
		to: (attachPoint endingPointOf: anEdge)
		width: (self widthFor: anEdge)
		size: (self mySize rtValue: anEdge)
		color: (self colorFor: anEdge)
		stroke: (self colorFor: anEdge).
	shape baseSize: (baseSize rtValue: anEdge).
	^ shape