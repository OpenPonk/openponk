running - stepping
step
	completed
		ifTrue: [ self error: 'The recognition has already finished.' ].
	self transitionStep.
	completed
		ifTrue: [ ^ self ].
	self wait.
	self stateStep.
	remainder isEmpty
		ifTrue: [ ^ self inputConsumed ].
	self announce: DCFsmRecognizerStepCompleted new