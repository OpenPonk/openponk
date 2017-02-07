hooks
initializeElement: aView
	aView canvas addShape: OPTRGridShape new.
	aView canvas
		addShape:
			(TRSVGPath new
				strokePaint: Color black;
				borderWidth: 1;
				path: 'M -5 0 H 5 M 0 -5 V 5')