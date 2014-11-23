hooks
createEdgeFrom: fromFigure to: toFigure
	| builder edge |
	builder := DCRTRelationshipBuilder new.
	edge := builder createEdgeFrom: fromFigure to: toFigure.
	edge shape emptyArrowHead.
	edge resetShape.
	edge shape color: Color black.
	^ edge