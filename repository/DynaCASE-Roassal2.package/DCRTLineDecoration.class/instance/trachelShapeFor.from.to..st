private
trachelShapeFor: anEdge from: fromPoint to: toPoint
	| shape |
	shape := self trachelShapeClass
		from: fromPoint
		to: toPoint
		width: (self widthFor: anEdge)
		size: (self mySize rtValue: anEdge)
		color: (self colorFor: anEdge)
		stroke: (self colorFor: anEdge).
	shape baseSize: (baseSize rtValue: anEdge).
	^ shape