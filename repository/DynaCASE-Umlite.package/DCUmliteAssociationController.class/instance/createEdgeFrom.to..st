hooks
createEdgeFrom: fromFigure to: toFigure
	| builder edge label sourceMultiplicityLabel targetMultiplicityLabel |
	^ DCRTCallbackBuilder
		block: [ :view | 
			builder := DCRTEdgeBuilder new.
			edge := builder createEdgeFrom: fromFigure to: toFigure.
			view add: edge.

			label := builder addLabelNamed: #name to: edge.
			builder constraint: label balance: 0.5 offset: -12.

			sourceMultiplicityLabel := builder addLabelNamed: #sourceMultiplicity to: edge.
			builder constraint: sourceMultiplicityLabel toSourceDistance: 10 offset: 12.

			targetMultiplicityLabel := builder addLabelNamed: #targetMultiplicity to: edge.
			builder constraint: targetMultiplicityLabel toTargetDistance: 10 offset: 12.

			edge ]