public - moving
move: aShape onTheTopRightOf: anotherShape withWidthPadding: widthPadding withHeightPadding: heightPadding
	| rectangle |
	rectangle := anotherShape encompassingRectangle topRight.
	^ aShape translateTo: ((rectangle x - (aShape width/2) - widthPadding)@(rectangle y + (aShape height/2) + heightPadding))