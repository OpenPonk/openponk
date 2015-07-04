tests
testAdd
	self assert: diagram elements isEmpty.
	diagram add: initial.
	diagram add: state.
	diagram add: firstTransition.
	self assertCollection: diagram ownedElements hasSameElements: (Array with: initial with: firstTransition with: state).
	self assert: initial owner equals: diagram.
	self assert: state owner equals: diagram.
	self assertCollection: initial outgoing hasSameElements: {firstTransition}.
	self assertCollection: state incoming hasSameElements: {firstTransition}