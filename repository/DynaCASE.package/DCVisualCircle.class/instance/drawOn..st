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
				cwArcTo: self radius angle: Float pi;
				cwArcTo: 0 - self radius angle: Float pi ].
	aCanvas
		setPaint: self fillColor;
		drawShape: path.
	stroke := aCanvas setStrokePaint: self strokeColor.
	stroke width: self strokeWidth.
	aCanvas draw