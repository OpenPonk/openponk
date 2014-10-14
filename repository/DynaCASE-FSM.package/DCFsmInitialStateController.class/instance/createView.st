initialization
createView
	| element shape activation |
	element := RTElement new.
	shape := RTEllipse new
		size: 14;
		color: self defaultColor.
	element + shape.
	element @ RTDraggable.
	element @ (activation := DCRTActivableWithBoundingBox new).
	activation
		activateWhen: TRMouseEnter
			deactivateWhen: TRMouseLeave
			priority: 10
			value: Color gray;
		activateWhen: DCTRSelectedEvent
			deactivateWhen: DCTRUnselectedEvent
			priority: 20
			value: Color blue.
	^ element