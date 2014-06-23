drawing
drawOn: aCanvas
	| path stroke |
	super drawOn: aCanvas.
	path := aCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: self p1;
				lineTo: self p2 ].
	stroke := aCanvas setStrokePaint: self strokeColor.
	stroke width: self strokeWidth.
	aCanvas drawShape: path.
	self drawSubnodesOn: aCanvas