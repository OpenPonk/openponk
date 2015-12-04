as yet unclassified
moveToBorder: aLine
	(aLine intersectRectangle: endElement encompassingRectangle)
		ifNotEmpty: [ :set | self basicMoveTo: set anyOne ]