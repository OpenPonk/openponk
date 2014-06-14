as yet unclassified
drawOn: aCanvas

|font path stroke|
	
	path := aCanvas createPath: [:builder |
		builder	absolute;
			moveTo: 10@0;
			lineTo: (width-10)@0;
			cwArcTo: width@10 angle: 90 degreesToRadians;
			lineTo: width@(heigth-10);
			cwArcTo: (width-10)@heigth angle: 90 degreesToRadians;
			lineTo: 10@heigth ;
			cwArcTo: 0@(heigth-10) angle: 90 degreesToRadians;
			lineTo: 0@10;
			cwArcTo: 10@0 angle: 90 degreesToRadians
].
	aCanvas setPaint: Color lightBlue; drawShape: path.
	
	stroke := aCanvas setStrokePaint: Color black.
	stroke width: 2.
	aCanvas draw.
	
	aCanvas setPaint: Color black; setFont: (font:=LogicalFont familyName: 'Arial' pointSize: 16).
	
	aCanvas pathTransform translateX: 15 Y: 20+(font getPreciseAscent).
	aCanvas drawString: name.
	aCanvas pathTransform translateX: -15 Y: -20-(font getPreciseAscent).