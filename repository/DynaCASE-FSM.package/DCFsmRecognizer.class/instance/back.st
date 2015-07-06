stepping
back
	path ifEmpty: [ ^ self ].
	self goTo: path pop.
	current isState
		ifTrue: [ input push: consumed pop ]