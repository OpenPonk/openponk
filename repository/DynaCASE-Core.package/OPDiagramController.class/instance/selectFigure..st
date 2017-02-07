protocol-canvas
selectFigure: aFigure
	| controller |
	controller := self controllerForFigure: aFigure.
	selectionHolder value: controller