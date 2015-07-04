tests
testRemoveState2
	diagram add: state.
	diagram add: selfTransition.

	state remove.
	self assert: state owner isNil.
	self assert: selfTransition source isNil.
	self assert: selfTransition target isNil.
	self assert: state outgoing isEmpty.
	self assert: state incoming isEmpty.
	self assert: diagram elements isEmpty