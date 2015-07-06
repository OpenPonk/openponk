stepping
next
	| transition |
	current isState & input isEmpty
		ifTrue: [ ^ self beComplete ].
	path push: current.
	current isTransition
		ifTrue: [ ^ self goTo: current target ].
	consumed push: input pop.
	transition := self transitionFrom: current using: consumed top.
	transition ifNil: [ ^ self beComplete ].
	self goTo: transition