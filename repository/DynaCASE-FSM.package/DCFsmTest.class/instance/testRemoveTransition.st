tests
testRemoveTransition
	diagram add: initial.
	diagram add: state.
	diagram add: firstTransition.

	self assert: diagram elements size equals: 3.

	firstTransition remove.
	self assert: diagram elements size equals: 2.
	self assert: initial outgoing isEmpty.
	self assert: state incoming isEmpty