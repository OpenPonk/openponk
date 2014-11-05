hooks
createEdgeFrom: fromFigure to: toFigure
	| builder edge label sourceMultiplicityLabel targetMultiplicityLabel |
	^ DCRTCallbackBuilder
		block: [ :view | 
			builder := DCRTRelationshipBuilder new.
			edge := builder createEdgeFrom: fromFigure to: toFigure.
			edge shape head: nil.
			view add: edge.
			label := builder addLabelTo: edge.
			builder constraint: label balance: 0.5 offset: -12.
			sourceMultiplicityLabel := builder addLabelTo: edge.
			builder constraint: sourceMultiplicityLabel toSourceDistance: 10 offset: 12.
			targetMultiplicityLabel := builder addLabelTo: edge.
			builder constraint: targetMultiplicityLabel toTargetDistance: 10 offset: 12.
			edge ]