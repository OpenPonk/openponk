public
createFigureFrom: fromElement to: toElement view: aView
	| edge |
	edge := self createEdgeFrom: fromElement to: toElement.
	edge @ OPRTFocusable.
	aView add: edge.
	self
		addLabelsTo: edge;
		applyConstraintsTo: edge.
	^ edge