initialization
createFigure
	| aFigure |
	aFigure := self roassalShapeClass new
		size: 50;
		color: Color transparent;
		borderColor: self defaultColor;
		elementOn: self model name.
	aFigure
		@
			(RTLabelled new
				view: self parent view;
				center;
				color: Color black;
				yourself).
	aFigure @ RTDraggable.
	aFigure @ DCRTFocusable.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			(aFigure attributeAt: #RTLabelledLabel) text: newValue.
			aFigure update.
			aFigure view signalUpdate ].
	^ aFigure