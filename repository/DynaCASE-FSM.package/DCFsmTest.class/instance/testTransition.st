tests
testTransition
	diagram add: initial.
	diagram add: state.

	self assert: initial outgoing isEmpty.
	self assert: state incoming isEmpty.
	self assert: firstTransition owner isNil.

	diagram add: firstTransition.
	self assert: firstTransition owner equals: diagram.
	self assertCollection: initial outgoing hasSameElements: {firstTransition}.
	self assertCollection: state incoming hasSameElements: {firstTransition}