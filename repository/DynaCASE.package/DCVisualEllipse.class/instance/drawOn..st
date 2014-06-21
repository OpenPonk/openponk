as yet unclassified
drawOn: aCanvas
	| path stroke |
	super drawOn: aCanvas.
	path := aCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: 0 @ 0.5;
				cwArcTo: 0.5 @ 0 angle: Float halfPi;
				cwArcTo: 1 @ 0.5 angle: Float halfPi;
				cwArcTo: 0.5 @ 1 angle: Float halfPi;
				cwArcTo: 0 @ 0.5 angle: Float halfPi ].
	aCanvas pathTransform
		restoreAfter: [ 
			aCanvas pathTransform translateBy: self position.
			aCanvas pathTransform scaleBy: 2 * (self radiusX @ self radiusY).
			aCanvas
				setPaint: self fillColor;
				drawShape: path.
			stroke := aCanvas setStrokePaint: self strokeColor.
			stroke width: (self strokeWidth / (self radiusX + self radiusY)) asFloat.
			aCanvas drawShape: path ]