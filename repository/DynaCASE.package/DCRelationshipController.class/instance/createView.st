hooks
createView
	| edge |
	edge := self createEdgeFrom: source view to: target view.
	^ edge