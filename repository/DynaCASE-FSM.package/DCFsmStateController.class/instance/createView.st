initialization
createView
	| element   activation |
	element := self roassalShapeClass new
		size: 50;
		color: Color transparent;
		borderColor: self defaultColor;
		elementOn: self model name.
	element
		@
			(RTLabelled new
				view: self parent view;
				center;
				color: Color black;
				yourself).
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
	self model nameHolder
		whenChangedDo: [ :newValue | 
			(element attributeAt: #RTLabelledLabel) text: newValue.
			element update.
			element view signalUpdate ].
	^ element