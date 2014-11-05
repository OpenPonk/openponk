hooks
createFigure
	| edge |
	edge := self createEdgeFrom: source figure to: target figure.
	^ edge