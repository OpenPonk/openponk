initialization
initializePresenter
	| element |
	lineButton
		action: [ 
			(element := DCVisualLine new) p1: 10 @ 10 p2: 50 @ 80.
			self onAction value: element ].
	polyLineButton
		action: [ 
			(element := DCVisualPolyLine new)
				addPoint: 0 @ 30;
				addPoint: 15 @ 0;
				addPoint: 20 @ 30.
			self onAction value: element ]