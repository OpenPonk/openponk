hooks
edgeBuilder
	^ DCRTEdgeBuilder new
		constraintLabel: #name balance: 0.5 offset: -12;
		constraintLabel: #sourceMultiplicity toSourceDistance: 10 offset: 12;
		constraintLabel: #targetMultiplicity toTargetDistance: 10 offset: 12;
		yourself