hooks
createEdgeFrom: fromFigure to: toFigure
	| builder edge |
	^ DCRTCallbackBuilder
		block: [ :view | 
			builder := DCRTRelationshipBuilder new.
			edge := builder createEdgeFrom: fromFigure to: toFigure.
			edge shape emptyArrowHead.
			edge resetShape.
			edge shape color: Color black.
			edge ]