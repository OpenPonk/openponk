running - stepping
stateStep
	self stateDeparted: state.
	self wait.
	state := transition target.
	self stateReached: state