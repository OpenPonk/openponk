public
createFigureFrom: fromElement to: toElement view: aView
	| edge |
	edge := self createEdgeFrom: fromElement to: toElement.
	edge @ DCRTFocusable.
	aView add: edge.
	self
		addLabelsTo: edge;
		applyConstraintsTo: edge.
	^ edge