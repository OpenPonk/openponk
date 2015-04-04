public - moving
move: aShape onTheBottomCenterOf: anotherShape withWidthPadding: widthPadding withHeightPadding: heightPadding
	| rectangle bl |
	rectangle := anotherShape encompassingRectangle.
	bl := rectangle bottomLeft.
	aShape translateTo: (bl x + (rectangle width / 2)) @ (bl y - aShape height)