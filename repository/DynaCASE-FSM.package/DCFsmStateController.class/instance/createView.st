initialization
createView
	| element |
	element := self roassalShapeClass new
		size: 50;
		color: Color transparent;
		borderColor: Color black;
		elementOn: self model name.
	element
		@
			(RTLabelled new
				view: self parent view;
				center;
				color: Color black;
				yourself).
	element @ RTDraggable.
	element @ DCRTActivableWithBoundingBox.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			(element attributeAt: #RTLabelledLabel) text: newValue.
			element update.
			element view signalUpdate ].
	^ element