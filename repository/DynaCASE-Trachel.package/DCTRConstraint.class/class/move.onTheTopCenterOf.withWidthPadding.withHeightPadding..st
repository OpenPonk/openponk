public - moving
move: aShape onTheTopCenterOf: anotherShape withWidthPadding: widthPadding withHeightPadding: heightPadding
	| rectangle tl |
	rectangle := anotherShape encompassingRectangle.
	tl := rectangle topLeft.
	aShape translateTo: (tl x + (rectangle width / 2) + (widthPadding / 2)) @ (tl y + (aShape height / 2))