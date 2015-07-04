tests
testRemoveState
	diagram add: initial.
	diagram add: state.
	diagram add: final.
	diagram add: firstTransition.
	diagram add: secondTransition.

	state remove.
	self assert: state owner isNil.
	self assert: firstTransition source isNil.
	self assert: secondTransition source isNil.
	self assert: initial outgoing isEmpty.
	self assert: state incoming isEmpty.
	self assertCollection: diagram elements hasSameElements: (Array with: initial with: final)