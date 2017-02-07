private
addScrollbars: aView
	| bottomBar |
	bottomBar := TRBoxShape new
		color: Color veryVeryLightGray;
		strokePaint: Color lightGray;
		width: aView canvas extent x / 2;
		height: 10;
		yourself.
	bottomBar translateTo: (aView canvas extent x / 2) @ (aView canvas extent y - 5).
	bottomBar
		when: TRMouseDragging
		do: [ :e | 
			| d step |
			step := e step x @ 0.
			d := aView canvas camera distanceFromPixelToSpace: step.
			d x > 0
				ifTrue: [ d := (d x min: aView canvas extent x - bottomBar encompassingRectangle right) @ 0 ]
				ifFalse: [ d := (d x max: bottomBar encompassingRectangle left negated) @ 0 ].
			bottomBar translateBy: d.
			aView canvas camera translateBy: d.
			e signalUpdate ].
	aView canvas addFixedShape: bottomBar