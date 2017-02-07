removing
deleteFigure: aFigure
	self diagramController deselectAll.
	self diagramController removeFromView: aFigure.
	self signalUpdate.