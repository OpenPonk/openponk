initialization
createFigure
	^ DCRTCallbackBuilder
		block: [ :view | 
			| aFigure |
			aFigure := self roassalShapeClass new
				size: 40;
				color: Color transparent;
				borderColor: self defaultColor;
				elementOn: ''.
			aFigure
				@
					(RTLabelled new
						view: view;
						center;
						color: Color black;
						yourself).
			aFigure @ RTDraggable.
			aFigure @ DCRTFocusable.
			aFigure ]