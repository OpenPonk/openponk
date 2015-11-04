visualization
addBoundingBoxFor: anElement
	| bb |
	bb := RTBox new
		borderColor: Color red;
		color: Color transparent;
		elementOn: anElement.
	bb extent: anElement extent.
	TRConstraint stick: bb onTheCenterOf: anElement.
	view add: bb.
	bb trachelShape
		pushBehind:
			((anElement isKindOf: TRShape)
				ifTrue: [ anElement ]
				ifFalse: [ anElement trachelShape ])