initialization
initializeWidgets
	super initializeWidgets.
	(circleButton := self newButton) label: 'Circle'.
	(ellipseButton := self newButton) label: 'Ellipse'.
	(polygonButton := self newButton) label: 'Polygon'.
	(rectangleButton := self newButton) label: 'Rectangle'