drawing
drawOn: aCanvas onPos: aPoint
	aCanvas pathTransform translateBy: aPoint.
	self drawOn: aCanvas.
	aCanvas pathTransform translateBy: aPoint negated