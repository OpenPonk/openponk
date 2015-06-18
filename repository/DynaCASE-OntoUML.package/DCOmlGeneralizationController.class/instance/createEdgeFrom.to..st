hooks
createEdgeFrom: fromFigure to: toFigure
	| builder edge |
	^ DCRTCallbackBuilder
		block: [ :view | 
			builder := DCRTEdgeBuilder new.
			edge := builder createEdgeFrom: fromFigure to: toFigure.
			edge shape emptyNarrowArrowHead.
			edge resetShape.
			edge shape color: Color black.
			edge ]