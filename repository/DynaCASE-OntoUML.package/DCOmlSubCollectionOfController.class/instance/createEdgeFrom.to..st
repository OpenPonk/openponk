hooks
createEdgeFrom: fromFigure to: toFigure
	| builder edge label sourceMultiplicityLabel targetMultiplicityLabel |
	^ DCRTCallbackBuilder
		block: [ :view | 
			builder := DCRTEdgeBuilder new.
			edge := builder createLineFrom: fromFigure to: toFigure.
			edge shape filledDiamondHead.
			edge resetShape.
			edge shape color: Color black.
			view add: edge.

			label := builder addLabelTo: edge.
			builder constraint: label balance: 0.5 offset: -12.

			sourceMultiplicityLabel := builder addLabelTo: edge.
			builder constraint: sourceMultiplicityLabel toSourceDistance: 10 offset: 12.

			targetMultiplicityLabel := builder addLabelTo: edge.
			builder constraint: targetMultiplicityLabel toTargetDistance: 10 offset: 12.
			edge ]