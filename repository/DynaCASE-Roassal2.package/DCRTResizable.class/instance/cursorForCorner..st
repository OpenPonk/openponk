accessing
cursorForCorner: aCorner
	^ Cursor perform: ('resize' , aCorner capitalized) asSymbol