private
trachelShapeFor: anEdge from: fromPoint to: toPoint
	| tShape |
	tShape := self trachelShapeClass
		from: fromPoint
		to: toPoint
		width: (self widthFor: anEdge)
		size: (self mySize rtValue: anEdge)
		color: (self colorFor: anEdge)
		stroke: (self colorFor: anEdge).
	tShape baseSize: (baseSize rtValue: anEdge).
	^ tShape