public
trachelShapeFor: anEdge from: aPoint
	| tShape |
	tShape := self trachelShapeClass
		from: aPoint
		to: (self targetPointOf: anEdge)
		width: (self widthFor: anEdge)
		size: (self mySize rtValue: anEdge)
		color: (self colorFor: anEdge)
		stroke: (self colorFor: anEdge).
	tShape baseSize: (baseSize rtValue: anEdge).
	^ tShape