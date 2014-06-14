as yet unclassified
mouseDown: anEvent

	anEvent redButtonPressed ifTrue: [ 
		lastPoint := anEvent cursorPoint.
			 ].