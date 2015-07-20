private
feedbackFor: anElement color: aColor
	(anElement isKindOf: RTElement)
		ifFalse: [ ^ self ].
	feedback := RTBox new
		color: (aColor alpha: 0.2);
		borderColor: aColor;
		element.
	DCTRConstraint keepExtentOf: feedback like: anElement plus: 3 @ 3.
	TRConstraint stick: feedback onTheCenterOf: anElement.
	anElement view add: feedback.
	anElement view signalUpdate.
	^ self