protocol-canvas
hoverFigure: aFigure
	| controller |
	controller := self controllerForFigure: aFigure.
	hoverHolder value: controller