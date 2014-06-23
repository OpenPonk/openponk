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
			lastPt := pointHandles first center- self position.
			builder moveTo: lastPt.
			pointHandles
				do: [ :pt | 
					newPt := pt center - lastPt - self position.
					lastPt := pt center- self position.
					builder lineTo: newPt ] ].
	stroke := aCanvas setStrokePaint: self strokeColor.
	stroke width: self strokeWidth.
	aCanvas drawShape: path.
	self drawSubnodesOn: aCanvas