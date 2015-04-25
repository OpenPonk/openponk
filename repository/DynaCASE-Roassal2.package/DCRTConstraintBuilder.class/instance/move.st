public - moving
move
	| rectangle xPosition yPosition |
	rectangle := parentShape encompassingRectangle.
	xPosition := horizontalPosition value: shape value: rectangle.
	yPosition := verticalPosition value: shape value: rectangle.
	shape translateTo: xPosition @ yPosition