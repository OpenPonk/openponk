private
feedbackFor: anElement color: aColor
	|shape|
	(anElement isKindOf: RTElement)
		ifFalse: [ ^ self ].
	shape := RTBox new.
	(anElement shape class = RTRoundedBox) | (anElement shape class = RTEllipse) ifTrue: [ 
		shape := RTEllipse new.
	].
	feedback := shape
		color: (aColor alpha: 0.05);
		borderColor: (aColor alpha: 0.05);
		element.
	noBorder
		ifTrue:
			[ 
			feedback trachelShape strokeWidth: 0.
			feedback trachelShape strokePaint: Color red ].
	DCRTElementsConstraint keepExtentOf: feedback like: anElement plus: 3 @ 3.
	TRConstraint stick: feedback onTheCenterOf: anElement.
	anElement view add: feedback.
	anElement view signalUpdate