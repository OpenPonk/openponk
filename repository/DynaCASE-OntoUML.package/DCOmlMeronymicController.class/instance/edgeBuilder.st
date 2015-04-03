hooks
edgeBuilder
	| builder |
	builder := DCRTEdgeBuilder new.
	(self model isNotNil and: [ self model isShareable ])
		ifTrue: [ builder emptyDiamondHead ]
		ifFalse: [ builder filledDiamondHead ].
	builder
		constraintLabel: #name balance: 0.5 offset: -12;
		constraintLabel: #meronymic below: #name;
		constraintLabel: #sourceMultiplicity toSourceDistance: 10 offset: 12;
		constraintLabel: #targetMultiplicity toTargetDistance: 10 offset: 12;
		addLabel: #qualifier text: self qualifier;
		constraintLabel: #qualifier toTargetDistance: 15 offset: -10.
	^ builder