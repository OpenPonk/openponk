drawing
drawOn: aCanvas
	| path stroke lastPt newPt |
	super drawOn: aCanvas.
	path := aCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: self position;
				relative.
			lastPt := points first.
			builder moveTo: lastPt.
			points
				do: [ :pt | 
					newPt := pt - lastPt.
					lastPt := pt.
					builder lineTo: newPt ].
			builder lineTo: points first - points last ].
	aCanvas
		setPaint: self fillColor;
		drawShape: path.
	stroke := aCanvas setStrokePaint: self strokeColor.
	stroke width: self strokeWidth.
	aCanvas draw