private
feedbackFor: aFigure color: aColor
	self removeFeedback.
	(aFigure isKindOf: RTElement)
		ifFalse: [ ^ self ].
	feedback := RTBox new
		color: (aColor alpha: 0.2);
		borderColor: aColor;
		element.
	DCTRConstraint keepExtentOf: feedback like: aFigure plus: 3 @ 3.
	TRConstraint stick: feedback onTheCenterOf: aFigure.
	aFigure view add: feedback.
	aFigure view signalUpdate