running - stepping
start
	state := model elements detect: #isInitial ifNone: [ self errorNoInitial ].
	transition := state outgoing first.
	self transitionReached: transition.
	state := transition target.
	self stateReached: state