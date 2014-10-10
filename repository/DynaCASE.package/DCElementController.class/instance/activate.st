interaction
activate
	| element |
	element := RTBox new
		color: Color transparent;
		borderColor: Color blue;
		element.
	TRConstraint stick: element onTheCenterOf: self view.
	DCTRConstraint keepExtentOf: element like: self view plus: 2 @ 2.
	^ element