as yet unclassified
drawOn: aCanvas

|font path stroke|
	
	path := aCanvas createPath: [:builder |
		builder	absolute;
			moveTo: 10@0;
			cwArcTo: 10@20 angle: 180 degreesToRadians;
			cwArcTo: 10@0 angle: 180 degreesToRadians
].
	aCanvas setPaint: Color lightYellow ; drawShape: path.
	
	stroke := aCanvas setStrokePaint: Color black.
	stroke width: 2.
	aCanvas draw.
	
	aCanvas setPaint: Color black; setFont: (font:=LogicalFont familyName: 'Arial' pointSize: 16).
	
	aCanvas pathTransform translateX: 15 Y: 20+(font getPreciseAscent).
	aCanvas drawString: name.
	aCanvas pathTransform translateX: -15 Y: -20-(font getPreciseAscent).