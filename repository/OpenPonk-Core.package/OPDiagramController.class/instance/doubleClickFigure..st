protocol-canvas
doubleClickFigure: aFigure
	| controller |
	controller := self controllerForFigure: aFigure.
	controller figureDoubleClicked.