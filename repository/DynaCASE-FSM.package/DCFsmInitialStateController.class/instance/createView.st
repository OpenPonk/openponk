initialization
createView
	| element shape |
	element := RTElement new.
	shape := RTEllipse new
		size: 14;
		color: Color black.
	element + shape.
	element @ RTDraggable.
	element @ DCRTActivableWithBoundingBox.
	^ element