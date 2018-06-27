private
highlight: anElement color: aColor
	| shape overlay |
	self hasStore
		ifTrue: [ ^ self ].
	model := anElement.
	shape := RTBox new.
	model shape class = RTRoundedBox
		ifTrue: [ (shape := RTRoundedBox new) borderRadius: (model shape borderRadiusFor: model) ].
	model shape class = RTEllipse
		ifTrue: [ shape := RTEllipse new ].
	overlay := shape
		color: (aColor alpha: 0.2);
		borderColor: (aColor alpha: 0.2);
		element.
	noBorder
		ifTrue: [ overlay trachelShape strokeWidth: 0.
			overlay trachelShape strokePaint: Color red ].
	OPRTElementsConstraint keepExtentOf: overlay like: model plus: 3 @ 3.
	TRConstraint stick: overlay onTheCenterOf: model.
	self store: overlay.
	model view add: overlay.
	model view signalUpdate