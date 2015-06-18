terminators
reachedDeadState
	self announce: (DCFsmStateDead state: state).
	^ self complete