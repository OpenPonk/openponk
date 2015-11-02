visualization
addBoundingBoxFor: anElement
	| bb |
	bb := RTBox new
		borderColor: Color red;
		color: Color transparent;
		elementOn: anElement.
	bb extent: anElement extent.
	TRConstraint stick: bb onTheCenterOf: anElement.
	anElement view add: bb.
	bb trachelShape pushBehind: anElement trachelShape