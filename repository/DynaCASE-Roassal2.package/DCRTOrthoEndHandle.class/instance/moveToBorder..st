as yet unclassified
moveToBorder: aLine
	self basicMoveTo: (aLine intersectRectangle: endElement encompassingRectangle) anyOne