hooks
createEdgeFrom: fromFigure to: toFigure
	^ DCRTCallbackBuilder
		block: [ :view | 
			| builder edge meronymicLabel sourceMultiplicityLabel targetMultiplicityLabel qualifier label |
			builder := DCRTEdgeBuilder new.
			edge := self model isShareable
				ifTrue: [ builder createEdgeFrom: fromFigure to: toFigure head: DCRTEmptyDiamond ]
				ifFalse: [ builder createEdgeFrom: fromFigure to: toFigure head: DCRTFilledDiamond ].
			view add: edge.
			label := builder addLabelNamed: #name to: edge.
			builder constraint: label balance: 0.5 offset: -12.
			meronymicLabel := builder addLabelNamed: #meronymic to: edge.
			builder constraint: meronymicLabel below: label.
			sourceMultiplicityLabel := builder addLabelNamed: #sourceMultiplicity to: edge.
			builder constraint: sourceMultiplicityLabel toSourceDistance: 10 offset: 12.
			targetMultiplicityLabel := builder addLabelNamed: #targetMultiplicity to: edge.
			builder constraint: targetMultiplicityLabel toTargetDistance: 10 offset: 12.
			self qualifier
				ifNotNil: [ 
					qualifier := builder addLabelNamed: #qualifier to: edge.
					qualifier trachelShape text: self qualifier.
					builder constraint: qualifier toTargetDistance: 15 offset: -10 ].
			edge ]