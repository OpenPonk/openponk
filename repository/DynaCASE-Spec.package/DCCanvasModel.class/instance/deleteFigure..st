removing
deleteFigure: aFigure
	diagramController removeFromView: aFigure.
	self signalUpdate