figures
createEdgeFor: anElement inView: view
	| aLabel aFigure |
	aFigure := DCRTArcLine new
		color: Color black;
		radius: 15;
		head: DCRTFilledNarrowArrow;
		edgeFrom: anElement to: anElement.

	aLabel := RTLabel new
		color: Color black;
		height: 11;
		elementOn: 'wut'.
	aFigure attributeAt: #DCArcLabel put: aLabel.
	DCRTArcLine constraintLabel: aLabel at: aFigure.
	view add: aLabel.

	aFigure @ DCRTFocusable.
	^ aFigure