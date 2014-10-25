public - resizing
changeExtentOf: aShape like: anotherShape plus: aPoint
	^ aShape extent: anotherShape encompassingRectangle extent + aPoint