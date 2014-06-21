drawing
drawOn: aCanvas
	| path stroke arcSize |
	super drawOn: aCanvas.
	arcSize := self borderRadius.
	path := aCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: self position;
				relative;
				moveTo: arcSize@0;
				lineTo: (self width - arcSize - arcSize) @ 0;
				cwArcTo: arcSize @ arcSize angle: 90 degreesToRadians;
				lineTo: 0 @ (self height - arcSize - arcSize);
				cwArcTo: (0 - arcSize) @ arcSize angle: 90 degreesToRadians;
				lineTo: (0 - self width + arcSize + arcSize) @ 0;
				cwArcTo: (0 - arcSize) @ (0 - arcSize) angle: 90 degreesToRadians;
				lineTo: 0 @ (0 - self height + arcSize + arcSize);
				cwArcTo: arcSize @ (0 - arcSize) angle: 90 degreesToRadians ].
	aCanvas
		setPaint: self fillColor;
		drawShape: path.
	stroke := aCanvas setStrokePaint: self strokeColor.
	stroke width: self strokeWidth.
	aCanvas draw