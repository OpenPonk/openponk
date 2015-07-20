stepping
back
	path ifEmpty: [ ^ self ].
	canContinue := true.
	self goTo: path pop.
	current isState
		ifTrue: [ input push: consumed pop ]