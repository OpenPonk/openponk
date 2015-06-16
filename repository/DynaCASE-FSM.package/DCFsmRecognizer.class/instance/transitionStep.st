running - stepping
transitionStep
	| s t |
	s := self nextSymbol.
	self symbolReached: s.
	t := self transitionFrom: state for: s.
	t ifNil: [ ^ self reachedDeadState ].
	self transitionDeparted: transition.
	transition := t.
	self transitionReached: transition