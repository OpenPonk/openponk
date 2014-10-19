initialization
createView
	| element |
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
	element @ DCRTFocusable.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			(element attributeAt: #RTLabelledLabel) text: newValue.
			element update.
			element view signalUpdate ].
	^ element