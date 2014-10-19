initialization
createView
	| element shape |
	element := RTElement new.
	shape := RTEllipse new
		size: 14;
		color: self defaultColor.
	element + shape.
	element @ RTDraggable.
	element @ DCRTFocusable.
	^ element