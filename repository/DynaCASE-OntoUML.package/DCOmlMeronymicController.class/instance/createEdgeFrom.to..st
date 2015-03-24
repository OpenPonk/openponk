hooks
createEdgeFrom: fromFigure to: toFigure
	^ DCRTCallbackBuilder
		block: [ :view | 
			| builder |
			builder := DCRTEdgeBuilder new.
			self model isShareable
				ifTrue: [ builder emptyDiamondHead ]
				ifFalse: [ builder filledDiamondHead ].
			builder
				constraintLabel: #name balance: 0.5 offset: -12;
				constraintLabel: #meronymic below: #name;
				constraintLabel: #sourceMultiplicity toSourceDistance: 10 offset: 12;
				constraintLabel: #targetMultiplicity toTargetDistance: 10 offset: 12;
				addLabel: self qualifier named: #qualifier;
				constraintLabel: #qualifier toTargetDistance: 15 offset: -10;
				createFigureFrom: fromFigure to: toFigure view: view ]