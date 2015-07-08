terminators
beComplete
	input isEmpty & current isFinal
		ifTrue: [ self beSuccess ]
		ifFalse: [ self beFailure ].
	canContinue := false