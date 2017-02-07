accessing
controllerForFigure: aFigure
	^ self controllers detect: [ :ctrl | ctrl figure = aFigure ]