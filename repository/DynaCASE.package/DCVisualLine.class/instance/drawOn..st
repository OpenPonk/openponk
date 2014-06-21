drawing
drawOn: aCanvas
	| path stroke |
	super drawOn: aCanvas.
	path := aCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: self position;
				relative;
				lineTo: self p2 - self p1 ].
	stroke := aCanvas setStrokePaint: self strokeColor.
	stroke width: self strokeWidth.
	aCanvas drawShape: path