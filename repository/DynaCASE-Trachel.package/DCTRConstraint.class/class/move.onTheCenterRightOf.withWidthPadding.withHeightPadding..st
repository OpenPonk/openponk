public - moving
move: aShape onTheCenterRightOf: anotherShape withWidthPadding: widthPadding withHeightPadding: heightPadding
	| rectangle rect |
	rect := anotherShape encompassingRectangle.
	rectangle := anotherShape encompassingRectangle topRight.
	^ aShape
		translateTo: (rectangle x - aShape width - widthPadding) @ (rectangle y + (rect height / 2) - (aShape height / 2))