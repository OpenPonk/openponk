hooks
initializeElement: anElement
	activationElement := RTBox new
		color: Color transparent;
		element.
	DCTRConstraint keepExtentOf: activationElement like: anElement plus: 3 @ 3.
	TRConstraint stick: activationElement onTheCenterOf: anElement.
	super initializeElement: anElement